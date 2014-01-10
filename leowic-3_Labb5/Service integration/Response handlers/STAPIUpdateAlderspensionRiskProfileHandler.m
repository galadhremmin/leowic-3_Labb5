//
//  STAPIUpdateAlderspensionRiskProfileHandler.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 09/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPIUpdateAlderspensionRiskProfileHandler.h"

@implementation STAPIUpdateAlderspensionRiskProfileHandler

-(id) handleResponseWithData: (NSDictionary *)responseData
{
    NSDictionary *root = [responseData objectForKey:@"UpdateAlderspensionRiskProfileResult"];
    id riskTendency = [root objectForKey:@"Level"];
    
    if (!riskTendency && riskTendency == [NSNull null]) {
        riskTendency = [NSNumber numberWithInt:0];
    }
    
    return riskTendency;
}

@end
