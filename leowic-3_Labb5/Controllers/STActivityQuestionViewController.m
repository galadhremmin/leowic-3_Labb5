//
//  STActivityQuestionViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STActivityQuestionViewController.h"
#import "STActivityLevelEnum.h"

@interface STActivityQuestionViewController ()

-(void) handleRiskProfile: (NSNumber *)calculatedRiskTendency;

@end

@implementation STActivityQuestionViewController

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator registerSelector:@selector(handleRiskProfile:) onDelegate:self forSignal:STAPIUpdateRiskProfile];
    [super viewWillAppear:animated];
}

-(void) handleRiskProfile: (NSNumber *)calculatedRiskTendency
{
    [self.coordinator.session.riskProfile setCalculatedRiskTendency:[calculatedRiskTendency intValue]];
    
    // Go to the next segue
    [self performSegueWithIdentifier:@"AdviceSegue" sender:nil];
}

-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    indexPath = [super tableView:tableView willSelectRowAtIndexPath:indexPath];
    if (!indexPath) {
        return nil;
    }
    
    // Update the risk profile and notify the service proxy of this change.
    STAPRiskProfileObject *risk = self.coordinator.session.riskProfile;    
    risk.activity = (STActivityLevelEnum) indexPath.row == 0
        ? STActivityLevelActive
        : STActivityLevelInactive;
    
    return indexPath;
}

@end
