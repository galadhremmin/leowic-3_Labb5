//
//  STFund.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 14/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPFundObject : NSObject

@property (nonatomic)       NSInteger   ID;
@property (nonatomic)       NSInteger   fundGroupID;
@property (nonatomic)       NSInteger   groupID;
@property (nonatomic)       NSUInteger  rating;
@property (nonatomic)       NSUInteger  share;
@property (nonatomic)       double      fee;
@property (nonatomic, copy) NSString   *name;

@end
