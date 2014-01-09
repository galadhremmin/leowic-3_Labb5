//
//  STAPGuideObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STAPRiskProfileObject.h"
#import "STAPPersonObject.h"

@interface STAPGuideObject : NSObject

@property (nonatomic)         NSUInteger             adviceID;
@property (nonatomic, strong) STAPPersonObject      *person;
@property (nonatomic, strong) STAPRiskProfileObject *riskProfile;

@end
