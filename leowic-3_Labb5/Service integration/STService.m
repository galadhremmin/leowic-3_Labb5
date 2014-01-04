//
//  STService.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 02/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STService.h"
#import "STServiceDelegate.h"
#import "STServiceConnection.h"

@implementation STService

-(id) initWithURL: (NSURL *)URL delegate:(NSObject<STServiceDelegate> *)delegate
{
    self = [super init];
    if (self) {
        [self setURL:URL];
        [self setDelegate:delegate];
    }
    return self;
}

-(void) execute: (NSString *)method methodID: (NSUInteger)methodID arguments: (NSDictionary *)arguments
{
    NSURL *requestURL = [_URL URLByAppendingPathComponent:method];
    NSString *postBody = [self convertDictionaryOfArgumentsToJSON:arguments];
    
    NSMutableURLRequest *serviceRequest = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    [serviceRequest setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPShouldHandleCookies:YES];
    [serviceRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    STServiceConnection *serviceConnection = [[STServiceConnection alloc] initWithRequest:serviceRequest methodName:method methodID:methodID delegate:self];
    [serviceConnection start];
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
    
    NSError *error;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:serviceConnection.receivedData options:0 error:&error];
    
    NSLog(@"%@ reply: %@", serviceConnection.methodName, data);
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"%@: %@ (expires %@)", cookie.name, cookie.value, cookie.expiresDate);
    }
    
    [self.delegate service:self finishedMethod:serviceConnection.methodName methodID:serviceConnection.methodID withData:data];
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

    [self.delegate service:self failedWithError:errorDescription];
}

@end
