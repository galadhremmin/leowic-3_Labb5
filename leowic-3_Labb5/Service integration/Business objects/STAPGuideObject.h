//
//  STAPGuideObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STAPRiskProfileObject.h"

@interface STAPGuideObject : NSObject

@property(atomic)         NSUInteger             adviceID;
@property(atomic, strong) STAPRiskProfileObject *riskProfile;

@end
