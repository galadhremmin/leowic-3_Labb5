//
//  STAPRiskProfileObject.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPRiskProfileObject.h"

@implementation STAPRiskProfileObject

-(id) init
{
    self = [super init];
    if (self) {
        NSMutableArray *answers = [[NSMutableArray alloc] init];
        [self setRiskQuestionAnswers:answers];
    }
    return self;
}

-(NSString *) calculatedRiskTendencyDescription
{
    switch (self.calculatedRiskTendency) {
        case STRiskLevelLow:
            return @"Låg";
        case STRiskLevelMidLow:
            return @"Medellåg";
        case STRiskLevelMidHigh:
            return @"Medelhög";
        case STRiskLevelHigh:
            return @"Hög";
        case STRiskLevelUnknown:
            return @"Okänd";
        default:
            [NSException raise:@"Okänd risknivå." format:@"Risknivån %d är okänd.", self.calculatedRiskTendency];
    }
    
    return nil;
}

-(NSUInteger) countOfRiskQuestionAnswers
{
    return self.riskQuestionAnswers.count;
}

-(id) objectInRiskQuestionAnswersAtIndex: (NSUInteger)index
{
    return [self.riskQuestionAnswers objectAtIndex:index];
}

-(void) addRiskQuestionAnswersObject: (NSNumber *)answer
{
    [self insertObject:answer inRiskQuestionAnswersAtIndex:self.riskQuestionAnswers.count];
}

-(void) insertObject: (id)object inRiskQuestionAnswersAtIndex: (NSUInteger)index
{
    [self.riskQuestionAnswers insertObject:object atIndex:index];
}

-(void) removeObjectFromRiskQuestionAnswersAtIndex: (NSUInteger)index
{
    [self.riskQuestionAnswers removeObjectAtIndex:index];
}

-(void) replaceObjectInRiskQuestionAnswersAtIndex: (NSUInteger)index withObject: (id)object
{
    [self.riskQuestionAnswers replaceObjectAtIndex:index withObject:object];
}

@end
