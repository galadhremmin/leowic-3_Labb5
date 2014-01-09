//
//  STAPPersonObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STAPPensionObject.h"
#import "STAPNameObject.h"

@interface STAPPersonObject : NSObject

@property (nonatomic)         NSInteger          personID;
@property (nonatomic)         NSInteger          visiPersonID;
@property (nonatomic)         NSUInteger         age;
@property (nonatomic)         NSUInteger         monthlyIncome;
@property (nonatomic, copy)   NSString          *civicRegistrationNumber;
@property (nonatomic, copy)   NSString          *email;
@property (nonatomic, strong) STAPPensionObject *pension;
@property (nonatomic, strong) STAPNameObject    *name;

@end
