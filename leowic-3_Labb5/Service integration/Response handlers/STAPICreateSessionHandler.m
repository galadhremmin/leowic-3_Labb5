//
//  STAPICreateSessionHandler.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPICreateSessionHandler.h"
#import "STAPGuideObject.h"
#import "STAPPensionObject.h"

@interface STAPICreateSessionHandler ()

-(void) populateSession: (STAPGuideObject *)guideSession withData: (NSDictionary *)data;
-(void) populateRiskProfile: (STAPRiskProfileObject *)riskProfile withData: (NSDictionary *)data;
-(void) populatePerson: (STAPPersonObject *)person withData: (NSDictionary *)data;
-(void) populatePension: (STAPPensionObject *)pension withData: (NSDictionary *)data;
-(void) populateName: (STAPNameObject *)name withData: (NSDictionary *)data;

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
    
    data = [root objectForKey:@"AffectedPerson"];
    [self populatePerson:session.person withData:data];
    
    return session;
}

-(void) populateSession: (STAPGuideObject *)guideSession withData: (NSDictionary *)data
{
    [guideSession setAdviceID:[[data objectForKey:@"AdviceId"] unsignedIntegerValue]];
}

-(void) populateRiskProfile: (STAPRiskProfileObject *)riskProfile withData: (NSDictionary *)data
{
    // Treat activity level with special care, as this might be null.
    [riskProfile setActivity:STActivityLevelUnknown];
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

-(void) populatePerson: (STAPPersonObject *)person withData: (NSDictionary *)data
{
    [person setPersonID:[[data objectForKey:@"PersonID"] integerValue]];
    [person setVisiPersonID:[[data objectForKey:@"VisiPersonID"] integerValue]];
    [person setAge:[[data objectForKey:@"Age"] unsignedIntegerValue]];
    [person setMonthlyIncome:[[data objectForKey:@"MonthlyIncome"] unsignedIntegerValue]];
    [person setCivicRegistrationNumber:[data objectForKey:@"CivicRegistrationNumber"]];
    [person setEmail:[data objectForKey:@"Email"]];
    
    [self populatePension:person.pension withData:[data objectForKey:@"Pension"]];
    [self populateName:person.name withData:[data objectForKey:@"Name"]];
}

-(void) populatePension: (STAPPensionObject *)pension withData: (NSDictionary *)data
{
    [pension setPensionType:(STPensionTypeEnum)[[data objectForKey:@"PensionType"] integerValue]];
    [pension setWorkedSinceYear:[[data objectForKey:@"WorkedSinceYear"] unsignedIntegerValue]];
}

-(void) populateName: (STAPNameObject *)name withData: (NSDictionary *)data
{
    [name setGivenName:[data objectForKey:@"GivenName"]];
    [name setSurname:[data objectForKey:@"Surname"]];
}

@end
