//
//  STAdviceStepViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAdviceStepViewController.h"
#import "STAPAdvice.h"

@interface STAdviceStepViewController ()

-(void) handleAdviceData: (id)data;

@end

@implementation STAdviceStepViewController

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator registerSelector:@selector(handleAdviceData:) onDelegate:self forSignal:STAPIRecommendationStep];
    
    [super viewWillAppear:animated];
    
    [self.coordinator.serviceProxy APIGetRecommendationStep:0];
}

-(void) handleAdviceData: (STAPAdvice *)adviceData
{
    NSLog(@"%@", adviceData);
}

@end
