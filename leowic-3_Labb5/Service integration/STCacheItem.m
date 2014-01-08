//
//  STCacheItem.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 07/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STCacheItem.h"

@implementation STCacheItem

-(id) initWithData: (id)data hash: (NSUInteger)hash
{
    self = [super init];
    if (self) {
        [self setData:data];
        [self setHash:hash];
        [self setDateAdded:[[NSDate alloc] init]];
    }
    return self;
}

@end
