//
//  STRiskQuestionViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 04/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STRiskQuestionViewController.h"
#import "STAPNotificationCoordinator.h"
#import "STAPServiceProxy.h"

@interface STRiskQuestionViewController ()

-(NSString *) previousSegueIdentifier;
-(NSString *) nextSegueIdentifier;
-(void) handleRiskProfile: (NSNumber *)calculatedRiskTendency;

@end

@implementation STRiskQuestionViewController

-(id) initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setQuestionIndex:0];
    }
    return self;
}

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator registerSelector:@selector(handleRiskProfile:) onDelegate:self forSignal:STAPIUpdateRiskProfile];
    [super viewWillAppear:animated];
}

-(NSString *) previousSegueIdentifier
{
    NSUInteger nextQuestionIndex = self.questionIndex > 0 ? self.questionIndex - 1 : 0;
    return [NSString stringWithFormat:@"RiskQuestionSegue%d", nextQuestionIndex];
}

-(NSString *) nextSegueIdentifier
{
    NSUInteger nextQuestionIndex = self.questionIndex + 1;
    return [NSString stringWithFormat:@"RiskQuestionSegue%d", nextQuestionIndex];
}

-(void) handleRiskProfile: (NSNumber *)calculatedRiskTendency
{
    [self.coordinator.session.riskProfile setCalculatedRiskTendency:[calculatedRiskTendency intValue]];
    
    // Go to the next segue
    [self performSegueWithIdentifier:self.nextSegueIdentifier sender:nil];
}

-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    indexPath = [super tableView:tableView willSelectRowAtIndexPath:indexPath];
    if (!indexPath) {
        return nil;
    }
    
    // Update the risk profile and notify the service proxy of this change.
    STAPRiskProfileObject *risk = self.coordinator.session.riskProfile;
    NSNumber *answer = [NSNumber numberWithInteger:indexPath.row];
    
    if (risk.riskQuestionAnswers.count <= self.questionIndex) {
        [risk addRiskQuestionAnswersObject:answer];
    } else {
        [risk replaceObjectInRiskQuestionAnswersAtIndex:self.questionIndex withObject:answer];
    }
    
    return indexPath;
}

-(void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    STRiskQuestionViewController *riskController = segue.destinationViewController;

    if (![riskController isKindOfClass:[self class]]) {
        return;
    }
    
    if ([segue.identifier isEqualToString:self.nextSegueIdentifier]) {
        riskController.questionIndex = self.questionIndex + 1;
        
    } else if ([segue.identifier isEqualToString:self.previousSegueIdentifier]) {
        riskController.questionIndex = self.questionIndex - 1;
        
    }
}

@end
