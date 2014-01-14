//
//  STAPCompany.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPCompany : NSObject

@property (nonatomic)         NSInteger       ID;
@property (nonatomic, copy)   NSString       *name;
@property (nonatomic, strong) NSMutableArray *funds;
@property (nonatomic)         NSUInteger      share;
@property (nonatomic)         double          fee;
@property (nonatomic)         BOOL            isTrad;
@property (nonatomic)         NSInteger       kapitaldelID;
@property (nonatomic)         NSInteger       productID;

@end
