//
//  STAPGuideObject.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPGuideObject.h"

@implementation STAPGuideObject

-(id) init
{
    self = [super init];
    if (self) {
        STAPRiskProfileObject *riskProfile = [[STAPRiskProfileObject alloc] init];
        [self setRiskProfile:riskProfile];
        
        STAPPersonObject *person = [[STAPPersonObject alloc] init];
        [self setPerson:person];
    }
    return self;
}

@end
