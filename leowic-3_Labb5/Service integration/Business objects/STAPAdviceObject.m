//
//  STAPAdvice.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPAdviceObject.h"

@implementation STAPAdviceObject

-(id) init
{
    self = [super init];
    if (self) {
        [self setCompanies:[[NSMutableArray alloc] init]];
    }
    return self;
}

@end
