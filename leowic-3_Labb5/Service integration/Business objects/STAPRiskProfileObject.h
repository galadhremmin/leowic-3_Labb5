//
//  STAPRiskProfileObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPRiskProfileObject : NSObject

@property(atomic)         NSInteger       activity;
@property(atomic)         NSInteger       currentRiskTendency;
@property(atomic)         NSInteger       calculatedRiskTendency;
@property(atomic, strong) NSMutableArray *riskQuestionAnswers;

@end
