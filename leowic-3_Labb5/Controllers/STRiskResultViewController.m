//
//  STRiskResultViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 10/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STRiskResultViewController.h"
#import "STAPNotificationCoordinator.h"
#import "STAPGuideObject.h"

@interface STRiskResultViewController ()

-(STAPNotificationCoordinator *) coordinator;

@end

@implementation STRiskResultViewController

-(STAPNotificationCoordinator *) coordinator
{
    return [STAPNotificationCoordinator sharedCoordinator];
}

-(void) viewWillAppear: (BOOL)animated
{
    STAPGuideObject *session = self.coordinator.session;
    
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"Your risk profile is %@.", nil), [session.riskProfile.calculatedRiskTendencyDescription lowercaseStringWithLocale:[NSLocale currentLocale]]];
    [self.riskResultLabel setText:text];
}

-(BOOL) shouldAutorotate
{
    return [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait;
}

@end
