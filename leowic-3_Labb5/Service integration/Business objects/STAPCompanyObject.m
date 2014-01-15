//
//  STAPCompany.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPCompanyObject.h"

@implementation STAPCompanyObject

-(id) init
{
    self = [super init];
    if (self) {
        [self setFunds:[[NSMutableArray alloc] init]];
    }
    return self;
}

@end
