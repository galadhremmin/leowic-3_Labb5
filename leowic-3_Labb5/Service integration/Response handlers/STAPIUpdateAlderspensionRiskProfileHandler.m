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
    id riskTendency = [NSNumber numberWithInt:0];
    if ([responseData isKindOfClass:[NSNull class]]) {
        return riskTendency;
    }
    
    id root = [responseData objectForKey:@"UpdateAlderspensionRiskProfileResult"];
    if ([root isKindOfClass:[NSNull class]]) {
        return riskTendency;
    }
    
    id tmp = [root objectForKey:@"Level"];
    if (tmp != [NSNull null])
        riskTendency = (NSNumber *)tmp;
    
    return riskTendency;
}

@end
