//
//  STServiceCacheConfiguration.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 05/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STServiceCacheConfiguration.h"

@interface STServiceCacheConfiguration ()

@property(nonatomic, strong) NSArray  *resetsOnSignals;

@end

@implementation STServiceCacheConfiguration

-(id) initWithResetForSignals: (NSArray *)signals
{
    self = [super init];
    if (self) {
        [self setResetsOnSignals:signals];
    }
    return self;
}

-(id) initWithHash: (NSUInteger)argumentsHash resetForSignals: (NSArray *)signals
{
    self = [super init];
    if (self) {
        [self setResetsOnSignals:signals];
        [self setCacheHashWithUnsignedInteger:argumentsHash];
    }
    return self;
}

-(void) setCacheHashWithUnsignedInteger: (NSUInteger)argumentsHash
{
    _cacheHash = [NSNumber numberWithUnsignedInteger:argumentsHash];
}

@end
