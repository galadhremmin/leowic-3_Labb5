//
//  STAPTestUser.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPTestUser.h"

@implementation STAPTestUser

-(id) initWithID: (NSUInteger)userID name: (NSString *)name
{
    self = [super init];
    if (self) {
        [self setUserID:userID];
        [self setName:name];
    }
    return self;
}

@end
