//
//  STAPService.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STService.h"
#import "STAPServiceProxy.h"
#import "STAPIResponseHandler.h"

@interface STAPServiceProxy ()

@property(nonatomic, strong) STService  *APIAuthenticationService;
@property(nonatomic, strong) STService  *APIGuideService;
@property(atomic)            NSUInteger  APIActiveRequests;
 
@end

@implementation STAPServiceProxy

+(NSString *) APIKey
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"API Key"];
}

+(void) setAPIKey: (NSString *)key
{
    if (key == nil || key.length < 64) {
        [NSException raise:@"Invalid API key." format:@"The key must consist of at least 64 characters."];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:key forKey:@"API Key"];
    [defaults synchronize];
}

+(STAPServiceProxy *) sharedProxy
{
    static STAPServiceProxy *instance = nil;
    if (instance == nil) {
        instance = [[STAPServiceProxy alloc] init];
    }
    
    return instance;
}

-(id) init
{
    self = [super init];
    if (self) {
        NSBundle *bundle = [NSBundle mainBundle];
        STService *service;
        NSURL *URL;
        
        URL = [NSURL URLWithString:[bundle objectForInfoDictionaryKey:@"API Authentication URL"]];
        service = [[STService alloc] initWithURL:URL delegate:self];
        [self setAPIAuthenticationService:service];

        URL = [NSURL URLWithString:[bundle objectForInfoDictionaryKey:@"API Guide URL"]];
        service = [[STService alloc] initWithURL:URL delegate:self];
        [self setAPIGuideService:service];
        
        [self setAPIActiveRequests:0];
    }
    return self;
}

-(void) addListener: (id)listener selector: (SEL)handler
{
    [[NSNotificationCenter defaultCenter] addObserver:listener selector:handler name:@"STAPServiceProxy" object:self];
}

-(void) removeListener: (id)listener
{
    [[NSNotificationCenter defaultCenter] removeObserver:listener name:@"STAPServiceProxy" object:self];
}

-(void) APIRequestLoginUsers
{
    // TODO: Acquire this list from the web service
    NSMutableDictionary *users = [[NSMutableDictionary alloc] init];
    
    [users setObject:@"Albert Camus, alternativ ITP" forKey:@"13"];
    [users setObject:@"Alice Munroe, ITP1" forKey:@"7"];
    [users setObject:@"Gabriel Marquez, alternativ ITP, inkomst över 10 IBB" forKey:@"10"];
    [users setObject:@"Gustav Curie, ITP2, inkomst under 7,5 IBB" forKey:@"6"];
    [users setObject:@"Kerstin Hemingway, ITP2, inkomst över 7,5 IBB" forKey:@"4"];
    [users setObject:@"Linus Lagerlöf, ITP1" forKey:@"3"];
    [users setObject:@"Mo Yan, ITP1 konverterad från ITP2, inkomst över 7,5 IBB" forKey:@"12"];
    [users setObject:@"Monika Röntgen, alternativ ITP" forKey:@"5"];
    [users setObject:@"Sigrid Undset, ITP1" forKey:@"8"];
    [users setObject:@"William Faulkner, ITP2, inkomst över 7,5 IBB" forKey:@"9"];
    [users setObject:@"Winston Churchill, ITP2" forKey:@"11"];
    
    [self service:_APIGuideService finishedMethod:@"ApiAvailableUsers" methodID:STAPIRequestLoginUsers withData:users];
}

-(void) APILoginUser: (int)userID
{
    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
    
    [arguments setValue:[STAPServiceProxy APIKey] forKey:@"serviceApiKey"];
    [arguments setValue:[NSNumber numberWithInt:userID] forKey:@"testUserId"];
    
    [_APIAuthenticationService execute:@"ApiAuthenticate" methodID:STAPILoginUser arguments:arguments];
    
    @synchronized(self) {
        [self setAPIActiveRequests:self.APIActiveRequests + 1];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

-(void) APIEstablishSession
{

}

#pragma mark - STServiceDelegation

-(void) service: (STService *)service finishedMethod: (NSString *)method methodID:(NSUInteger)methodID withData: (NSDictionary *)jsonData
{
    // Build the class name for the converter class. The converter class will translate the
    // dictionary into business objects.
    NSString *className = [NSString stringWithFormat:@"STAPI%@Handler", method];
    Class blueprint = NSClassFromString(className);
    
    if (blueprint == nil) {
        [NSException raise:@"Unrecognised API response handler." format:@"A handler for %@ (%@) wasn't found.", method, className];
    }
    
    NSObject<STAPIResponseHandler> *handler = [[blueprint alloc] init];
    
    // Performs the translation. We don't know the returning data type, hence _id_ in this case.
    id data = [handler handleResponseWithData:jsonData];
    
    // Connstruct a user info dictionary, which unfortunately is the only viable way to relay the
    // response data.
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              data, @"data",
                              [NSNumber numberWithUnsignedInteger:methodID], @"methodID",
                              nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STAPServiceProxy" object:self userInfo:userInfo];
    
    [self handleRequest];
}

-(void) service: (STService *)service failedWithError: (NSDictionary *)errorData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STAPServiceProxy" object:self userInfo:errorData];
    
    [self handleRequest];
}

-(void) handleRequest
{
    @synchronized(self) {
        // Some requests don't require network activity, so protect against potential integer overflow
        // by checking the current number of active requests.
        NSUInteger requests = self.APIActiveRequests > 0 ? self.APIActiveRequests - 1 : 0;
        [self setAPIActiveRequests:requests];
        
        if (requests < 1) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
}

@end
