//
//  STAPICompleteSessionHandler.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 16/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPICompleteSessionHandler.h"
#import "STAPCompletedAdviceObject.h"

@implementation STAPICompleteSessionHandler

-(id) handleResponseWithData: (NSDictionary *)responseData
{
    NSDictionary *root = [responseData objectForKey:@"CompleteSessionResult"];
    STAPCompletedAdviceObject *advice = [[STAPCompletedAdviceObject alloc] init];
    
    [advice setAdviceID:[[root objectForKey:@"AdviceID"] integerValue]];

    return advice;
}

@end
