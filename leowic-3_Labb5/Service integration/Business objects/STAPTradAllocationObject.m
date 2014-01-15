//
//  STTraditionalAllocationObject.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPTradAllocationObject.h"

@implementation STAPTradAllocationObject

-(id) initWithInterest: (double)interest shares: (double)shares property: (double)property other: (double)other
{
    self = [super init];
    if (self) {
        [self setDistributionInterest:interest];
        [self setDistributionShares:shares];
        [self setDistributionProperty:property];
        [self setDistributionOther:other];
    }
    
    return self;
}

@end
