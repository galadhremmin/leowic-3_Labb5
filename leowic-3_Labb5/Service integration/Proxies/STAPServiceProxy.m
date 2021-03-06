//
//  STAPService.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STServiceCacheConfiguration.h"
#import "STAdviceTypeEnum.h"
#import "STService.h"
#import "STAPServiceProxy.h"
#import "STAPIResponseHandler.h"

@interface STAPServiceProxy ()

@property (nonatomic, strong) STService *APIAuthenticationService;
@property (nonatomic, strong) STService *APIGuideService;
@property (nonatomic, copy)   NSString  *APISummaryURLFragment;

-(void) notifyMethodsCompletion: (NSUInteger)methodID data: (id)data;

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
        
        NSString *URLFragment = [bundle objectForInfoDictionaryKey:@"API Summary URL fragment"];
        [self setAPISummaryURLFragment:URLFragment];
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
    // The API appears to assume that you know about these individuals already. Unfortunately,
    // you can't acquire this list. For this reason, I've settled to hard-code them.
    NSMutableDictionary *users = [[NSMutableDictionary alloc] init];

    [users setObject:@"Gustav Curie, ITP2, inkomst under 7,5 IBB" forKey:@"6"];
    [users setObject:@"Kerstin Hemingway, ITP2, inkomst över 7,5 IBB" forKey:@"4"];
    [users setObject:@"Linus Lagerlöf, ITP1" forKey:@"3"];
    [users setObject:@"Monika Röntgen, alternativ ITP" forKey:@"5"];
    
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

-(void) APIInitializeRecommendationSteps
{
    // Some individuals might have fribrev of substantial value, resulting in their
    // immediate inclusion in the default collection of pension holdings. Instruct the
    // API that we want recommendations for ITP and PPM, and nothing else. The empty
    // array of "fribrev" would otherwise contain fribrev IDs.
    NSDictionary *arguments = @{@"categories": @[@(STAdviceTypeITP), @(STAdviceTypePPM)],
                                @"fribrev": @[]};
    
    [self.APIGuideService execute:@"UpdateAlderspensionAdviceRequirements" methodID:STAPIUpdateRequirements arguments:arguments cache:NO];
    
    [self.APIGuideService execute:@"InitializeRecommendationSteps" methodID:STAPIInitializeRecommendationSteps arguments:nil cache:NO];
}

-(void) APIGetRecommendationStep: (NSUInteger)category
{
    NSDictionary *arguments = @{@"category": @(category),
                                @"fribrevVisiID": @(0)};
    [self.APIGuideService execute:@"GetRecommendationStep" methodID:STAPIRecommendationStep arguments:arguments cache:NO];
}

-(void) APIGetFundData: (NSInteger)fundID
{
    NSDictionary *arguments = @{@"fundID": @(fundID)};
    [self.APIGuideService execute:@"GetFundData" methodID:STAPIGetFundData arguments:arguments cache:NO];
}

-(void) APIGetRecommendations
{
    NSDictionary *arguments = @{@"needs": [NSNull null]};
    [self.APIGuideService execute:@"GetRecommendation" methodID:STAPIGetRecommendations arguments:arguments cache:NO];
}

-(void) APICompleteGuideSession
{
    [self.APIGuideService execute:@"CompleteSession" methodID:STAPICompleteGuideSession arguments:nil cache:NO];
}

-(void) APIGetSummary: (NSInteger)adviceID
{
    [self.APIGuideService executeURLWithRawData:[self buildSummaryURL:adviceID] methodID:STAPIGetAdviceSummary];
}

-(NSURL *) buildSummaryURL: (NSInteger)adviceID
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:self.APISummaryURLFragment, adviceID]];
    return url;
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
        @try {
            data = [handler handleResponseWithData:jsonData];
        }
        @catch (NSException *exception) {
            [self service:service failedWithError:exception.userInfo];
            return; // <-- cancel, as the parsing failed.
        }
    }
    
    [self notifyMethodsCompletion:methodID data:data];
}

-(void) service: (STService *)service finishedMethodID: (NSUInteger)methodID withRawData: (NSData *)data
{
    [self notifyMethodsCompletion:methodID data:data];
}

-(void) service: (STService *)service failedWithError: (NSDictionary *)errorData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STAPServiceProxy" object:self userInfo:errorData];
}

-(void) notifyMethodsCompletion: (NSUInteger)methodID data: (id)data
{
    // The NSDictionary object does not accept nil, so assign all nil values to NSNull.
    if (!data) {
        data = [NSNull null];
    }
    
    // Relay the response data through an user info dictionary associated with the
    // notification. It's up to the listeners to understand the nature of the data
    // they receive.
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              data, @"data",
                              [NSNumber numberWithUnsignedInteger:methodID], @"methodID",
                              nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STAPServiceProxy" object:self userInfo:userInfo];
}

@end
