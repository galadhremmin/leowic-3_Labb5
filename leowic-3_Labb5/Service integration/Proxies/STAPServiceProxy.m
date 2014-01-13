//
//  STAPService.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STServiceCacheConfiguration.h"
#import "STService.h"
#import "STAPServiceProxy.h"
#import "STAPIResponseHandler.h"

@interface STAPServiceProxy ()

@property(nonatomic, strong) STService   *APIAuthenticationService;
@property(nonatomic, strong) STService   *APIGuideService;
 
@end

@implementation STAPServiceProxy

+(NSString *) APIKey
{
    NSString *key = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"API Key"];
    if (!key) {
        return @"";
    }
    
    return key;
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
    
    [self service:self.APIAuthenticationService finishedMethod:@"ApiAvailableUsers" methodID:STAPIRequestLoginUsers withData:users];
}

-(void) APILoginUser: (int)userID
{
    NSDictionary *arguments = @{ @"serviceApiKey": [STAPServiceProxy APIKey],
                                 @"testUserId": [NSNumber numberWithInt:userID] };
    
    [self.APIAuthenticationService clearCache];
    [self.APIGuideService clearCache];
    
    [self.APIAuthenticationService execute:@"ApiAuthenticate" methodID:STAPILoginUser arguments:arguments cache:NO];
}

-(void) APICreateGuideSession
{
    NSDictionary *arguments = @{@"resume":@"false",
                                @"type":@"Placering"};
    
    [self.APIGuideService execute:@"CreateSession" methodID:STAPIEstablishSession arguments:arguments cache:YES];
}

-(void) APIUpdateRiskProfile: (STAPRiskProfileObject *)riskProfile
{
    id        activity  = [NSNull null];
    NSNumber *riskLevel = [NSNumber numberWithInteger:riskProfile.calculatedRiskTendency];
    
    if (riskProfile.activity != STActivityLevelUnknown) {
        activity = [NSNumber numberWithInteger:riskProfile.activity];
    }
    
    NSDictionary *arguments = @{@"riskLevel":     riskLevel,
                                @"answers":       riskProfile.riskQuestionAnswers,
                                @"activityLevel": activity};
    
    [self.APIGuideService execute:@"UpdateAlderspensionRiskProfile" methodID:STAPIUpdateRiskProfile arguments:arguments cache:NO];
}

#pragma mark - STServiceDelegation

-(BOOL) isActive
{
    return self.APIAuthenticationService.activeRequests + self.APIGuideService.activeRequests > 0;
}

-(void) service: (STService *)service finishedMethod: (NSString *)method methodID: (NSUInteger)methodID withData: (NSDictionary *)jsonData
{
    // Default : no data. This only applies when there is no response handler.
    id data = nil;
    
    // Build the class name for the converter class. The converter class will translate the
    // dictionary into business objects.
    NSString *className = [NSString stringWithFormat:@"STAPI%@Handler", method];
    Class handlerBlueprint = NSClassFromString(className);
    
    if (handlerBlueprint == nil) {
        NSLog(@"Missing API response handler. A handler for %@ (%@) wasn't found.", method, className);
        
    } else {
        NSObject<STAPIResponseHandler> *handler = [[handlerBlueprint alloc] init];
    
        // Performs the translation. We don't know the returning data type, hence _id_ in this case.
        data = [handler handleResponseWithData:jsonData];
    }
    
    // The NSDictionary object does not accept nil, so assign all nil values to NSNull.
    if (!data) {
        data = [NSNull null];
    }
    
    // Connstruct a user info dictionary, which unfortunately is the only viable way to relay the
    // response data.
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              data, @"data",
                              [NSNumber numberWithUnsignedInteger:methodID], @"methodID",
                              nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STAPServiceProxy" object:self userInfo:userInfo];
}

-(void) service: (STService *)service failedWithError: (NSDictionary *)errorData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STAPServiceProxy" object:self userInfo:errorData];
}

@end
