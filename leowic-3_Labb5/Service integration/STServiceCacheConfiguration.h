//
//  STServiceCacheConfiguration.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 05/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STNotificationCoordinator.h"

@interface STServiceCacheConfiguration : STNotificationCoordinator

@property(nonatomic, readonly, strong) NSArray  *resetsOnSignals;
@property(nonatomic, readonly, strong) NSNumber *cacheHash;

-(id) initWithResetForSignals: (NSArray *)signals;
-(id) initWithHash: (NSUInteger)cacheHash resetForSignals: (NSArray *)signals;
-(void) setCacheHashWithUnsignedInteger: (NSUInteger)cacheHash;

@end
