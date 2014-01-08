//
//  STAPPersonObject.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPPersonObject.h"

@implementation STAPPersonObject

-(id) init
{
    self = [super init];
    if (self) {
        STAPPensionObject *pension = [[STAPPensionObject alloc] init];
        [self setPension:pension];
        
        STAPNameObject *name = [[STAPNameObject alloc] init];
        [self setName:name];
    }
    return self;
}

@end
