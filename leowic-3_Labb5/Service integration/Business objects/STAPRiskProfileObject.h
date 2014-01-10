//
//  STAPRiskProfileObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPRiskProfileObject : NSObject

@property(nonatomic)         NSInteger       activity;
@property(nonatomic)         NSInteger       currentRiskTendency;
@property(nonatomic)         NSInteger       calculatedRiskTendency;
@property(nonatomic, strong) NSMutableArray *riskQuestionAnswers;

// String description for calculated risk tendency
-(NSString *) calculatedRiskTendencyDescription;

// KVO for riskQuestionAnswers
-(NSUInteger) countOfRiskQuestionAnswers;
-(id) objectInRiskQuestionAnswersAtIndex: (NSUInteger)index;
-(void) addRiskQuestionAnswersObject: (NSNumber *)answer;
-(void) insertObject: (id)object inRiskQuestionAnswersAtIndex: (NSUInteger)index;
-(void) removeObjectFromRiskQuestionAnswersAtIndex: (NSUInteger)index;
-(void) replaceObjectInRiskQuestionAnswersAtIndex: (NSUInteger)index withObject: (id)object;

@end
