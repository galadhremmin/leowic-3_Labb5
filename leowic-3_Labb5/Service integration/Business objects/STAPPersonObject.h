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

@property (atomic)         NSInteger          personID;
@property (atomic)         NSInteger          visiPersonID;
@property (atomic)         NSUInteger         age;
@property (atomic)         NSUInteger         monthlyIncome;
@property (atomic, copy)   NSString          *civicRegistrationNumber;
@property (atomic, copy)   NSString          *email;
@property (atomic, strong) STAPPensionObject *pension;
@property (atomic, strong) STAPNameObject    *name;

@end
