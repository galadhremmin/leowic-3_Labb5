//
//  STService.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 02/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STCacheItem.h"
#import "STService.h"
#import "STServiceDelegate.h"
#import "STServiceConnection.h"

@interface STService ()

@property(atomic, strong) NSMutableArray *executionQueue;
@property(atomic, strong) NSCache        *cache;
@property(atomic)         NSUInteger      activeRequests;

@end

@implementation STService

-(id) initWithURL: (NSURL *)URL delegate:(NSObject<STServiceDelegate> *)delegate
{
    self = [super init];
    if (self) {
        [self setURL:URL];
        [self setActiveRequests:0];
        [self setDelegate:delegate];
        [self setCache:nil];
        [self setExecutionQueue:nil];
    }
    return self;
}

-(void) execute: (NSString *)method methodID: (NSUInteger)methodID arguments: (NSDictionary *)arguments cache: (STServiceCacheConfiguration *)cacheConfiguration
{
    if (self.executionQueue == nil) {
        NSMutableArray *queue = [[NSMutableArray alloc] init];
        [self setExecutionQueue:queue];
    }
    
    // Inject cache hash unless inferred.
    if (cacheConfiguration != nil && cacheConfiguration.cacheHash == nil) {
        [cacheConfiguration setCacheHashWithUnsignedInteger:arguments.hash];
    }
    
    // There is no data, so build a request to the web server
    NSURL *requestURL = [_URL URLByAppendingPathComponent:method];
    NSString *postBody = [self convertDictionaryOfArgumentsToJSON:arguments];
    
    NSMutableURLRequest *serviceRequest = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    [serviceRequest setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPShouldHandleCookies:YES];
    [serviceRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    STServiceConnection *serviceConnection = [[STServiceConnection alloc] initWithRequest:serviceRequest methodName:method methodID:methodID cache:cacheConfiguration delegate:self];
    
    @synchronized(_executionQueue) {
        [self.executionQueue addObject:serviceConnection];
        
        if (self.executionQueue.count == 1) {
            [self executeNext];
        }
    }
}

-(void) executeNext
{
    // Dequeue a service connection
    STServiceConnection *serviceConnection;
    @synchronized(_executionQueue) {
        if (self.executionQueue.count < 1) {
            return;
        }
        
        serviceConnection = (STServiceConnection *) [self.executionQueue firstObject];
        [self.executionQueue removeObject:serviceConnection];
    }
    
    if (self.cache != nil && serviceConnection.cacheConfiguration != nil) {
        STCacheItem *item = [self.cache objectForKey:serviceConnection.methodName];
        if (item != nil) {
            if (item.hash == [serviceConnection.cacheConfiguration.cacheHash unsignedIntegerValue]) {
                // There's an item in the cache  which is up to date.
                [self method:serviceConnection.methodName withID:serviceConnection.methodID didReceiveData:item.data];
                return;
            }
            
            // The cache is either out-dated or no longer relevant. Remove it from the collection.
            [self.cache removeObjectForKey:serviceConnection.methodName];
        }
    }
    
    // The service communication will happen asynchronously
    [serviceConnection start];
    
    // Notify the client that the phone's data traffic is in use
    [self beginDataTraffic];
}

-(NSString *) convertDictionaryOfArgumentsToJSON: (NSDictionary *)arguments
{
    if (arguments == nil || arguments.count < 1) {
        return nil;
    }
    
    NSError *serializationError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arguments options:NSJSONWritingPrettyPrinted error:&serializationError];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Error: %@", serializationError);
    NSLog(@"Arguments: %@", json);
    
    return json;
}

#pragma mark - Connection delegation

-(void) connection: (NSURLConnection *)connection didReceiveData: (NSData *)data
{
    STServiceConnection *serviceConnection = (STServiceConnection *)connection;
    [serviceConnection.receivedData appendData:data];
}

-(void) connectionDidFinishLoading: (NSURLConnection *)connection
{
    STServiceConnection *serviceConnection = (STServiceConnection *)connection;
    
    if (serviceConnection.cacheConfiguration != nil) {
        if (self.cache == nil) {
            self.cache = [[NSCache alloc] init];
        }
        
        STCacheItem *item = [[STCacheItem alloc] initWithData:serviceConnection.receivedData hash:[serviceConnection.cacheConfiguration.cacheHash unsignedIntegerValue]];
        [self.cache setObject:item forKey:serviceConnection.methodName];
    }
    
    [self endDataTraffic];
    
    [self method:serviceConnection.methodName withID:serviceConnection.methodID didReceiveData:serviceConnection.receivedData];
}

-(void) connection: (NSURLConnection *)connection didFailWithError: (NSError *)error
{
    // Send a failure signal, in case some of the controllers are listening to this
    NSDictionary *errorDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:YES], @"error",
                                      error.localizedDescription, @"localizedDescription",
                                      error.localizedFailureReason, @"localizedFailureReason",
                                      error.localizedRecoveryOptions, @"localizedRecoveryOptions",
                                      error.localizedRecoverySuggestion, @"localizedRecoverySuggestion",
                                      nil];

    [self endDataTraffic];
    [self executeNext];
    
    [self.delegate service:self failedWithError:errorDescription];
}

#pragma mark - Handlers for response data 

-(void) method: (NSString *)methodName withID: (NSUInteger)methodID didReceiveData: (NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSLog(@"%@ reply: %@", methodName, json);
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"%@: %@ (expires %@)", cookie.name, cookie.value, cookie.expiresDate);
    }

    [self executeNext];
    [self.delegate service:self finishedMethod:methodName methodID:methodID withData:json];
}

#pragma mark - Data connection activity indicator

-(void) beginDataTraffic
{
    @synchronized(self) {
        [self setActiveRequests:self.activeRequests + 1];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

-(void) endDataTraffic
{
    @synchronized(self) {
        // Some requests don't require network activity, so protect against potential integer overflow
        // by checking the current number of active requests.
        NSUInteger requests = self.activeRequests > 0 ? self.activeRequests - 1 : 0;
        [self setActiveRequests:requests];
        
        if (requests < 1) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
}

@end
