//
//  STAPIGetFundDataHandler.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPIGetFundDataHandler.h"
#import "STAPFundDataObject.h"

@implementation STAPIGetFundDataHandler

-(id) handleResponseWithData: (NSDictionary *)responseData
{
    NSDictionary *root = [responseData objectForKey:@"GetFundDataResult"];
    STAPFundDataObject *data = [[STAPFundDataObject alloc] init];
    
    if (!root) {
        return data;
    }
    
    id value = [root objectForKey:@"PPMFundNumber"];
    if (value != [NSNull null]) {
        [data setPPMCode:value];
    }
    
    value = [root objectForKey:@"IsinCode"]; // Discrepancy in the API! Ought to be ISIN?
    if (value != [NSNull null]) {
        [data setISINCode:value];
    }
    
    value = [root objectForKey:@"Currency"];
    if (value != [NSNull null]) {
        [data setCurrency:value];
    }
    
    value = [root objectForKey:@"ReturnFirstMonth"];
    [data setReturnFirstMonth:[value doubleValue]];
    
    value = [root objectForKey:@"ReturnThreeMonths"];
    [data setReturnThreeMonths:[value doubleValue]];
    
    value = [root objectForKey:@"ReturnFirstYear"];
    [data setReturnFirstYear:[value doubleValue]];
    
    value = [root objectForKey:@"ReturnThreeYears"];
    [data setReturnThreeYears:[value doubleValue]];
    
    value = [root objectForKey:@"ReturnFiveYears"];
    [data setReturnFiveYears:[value doubleValue]];
    
    return data;
}

@end
