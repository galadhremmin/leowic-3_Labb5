//
//  STAPICreateSessionHandler.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPICreateSessionHandler.h"
#import "STAPGuideObject.h"

@interface STAPICreateSessionHandler ()

-(void) populateSession: (STAPGuideObject *)guideSession withData: (NSDictionary *)data;
-(void) populateRiskProfile: (STAPRiskProfileObject *)riskProfile withData: (NSDictionary *)data;

@end

@implementation STAPICreateSessionHandler

-(id) handleResponseWithData: (NSDictionary *)responseData
{
    STAPGuideObject *session = [[STAPGuideObject alloc] init];
    NSDictionary *root = [responseData objectForKey:@"CreateSessionResult"], *data;
    
    data = root;
    [self populateSession:session withData:data];
    
    data = [root objectForKey:@"AdviceRiskProfile"];
    [self populateRiskProfile:session.riskProfile withData:data];
    
    return session;
}

-(void) populateSession: (STAPGuideObject *)guideSession withData: (NSDictionary *)data
{
    [guideSession setAdviceID:[[data objectForKey:@"AdviceId"] unsignedIntegerValue]];
}

-(void) populateRiskProfile: (STAPRiskProfileObject *)riskProfile withData: (NSDictionary *)data
{
    // Treat activity level with special care, as this might be null.
    [riskProfile setActivity:-1];
    id activity = [data objectForKey:@"Activity"];
    if (activity && activity != [NSNull null]) {
        [riskProfile setActivity:[activity integerValue]];
    }
    
    // The API always returns integers for the risk tendency values. Null pointer checks aren't
    // necessary.
    [riskProfile setCurrentRiskTendency:[[data objectForKey:@"CurrentRiskLevel"] integerValue]];
    [riskProfile setCalculatedRiskTendency:[[data objectForKey:@"Level"] integerValue]];
    
    NSArray *answers = [data objectForKey:@"ChosenAnswers"];
    for (NSNumber *answer in answers) {
        [riskProfile.riskQuestionAnswers addObject:answer];
    }
}

@end
