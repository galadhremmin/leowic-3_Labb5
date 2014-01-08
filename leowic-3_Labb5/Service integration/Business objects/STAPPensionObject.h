//
//  STAPPensionObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPensionTypeEnum.h"

@interface STAPPensionObject : NSObject

@property (atomic) STPensionTypeEnum  pensionType;
@property (atomic) NSUInteger         workedSinceYear;

@end