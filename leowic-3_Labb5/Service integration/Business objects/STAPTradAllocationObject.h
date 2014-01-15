//
//  STTraditionalAllocationObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPTradAllocationObject : NSObject

@property (nonatomic) double distributionInterest;
@property (nonatomic) double distributionOther;
@property (nonatomic) double distributionProperty;
@property (nonatomic) double distributionShares;

-(id) initWithInterest: (double)interest shares: (double)shares property: (double)property other: (double)other;

@end
