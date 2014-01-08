//
//  STAPRiskProfileObject.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPRiskProfileObject.h"

@implementation STAPRiskProfileObject

-(id) init
{
    self = [super init];
    if (self) {
        NSMutableArray *answers = [[NSMutableArray alloc] init];
        [self setRiskQuestionAnswers:answers];
    }
    return self;
}


@end
