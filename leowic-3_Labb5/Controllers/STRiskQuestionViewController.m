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

@property(nonatomic) UITableViewCell *selectedQuestionCell;

-(STAPNotificationCoordinator *) coordinator;
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
    [self.coordinator startCoordination];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [self.coordinator stopCoordination];
    
    if (self.selectedQuestionCell) {
        [self.selectedQuestionCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.selectedQuestionCell setAccessoryView:nil];
    }
}

-(STAPNotificationCoordinator *) coordinator
{
    return [STAPNotificationCoordinator sharedCoordinator];
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
    // If the service proxy is still handling requests, wait for it to finish before
    // enabling the client to move on.
    if (self.coordinator.serviceProxy.isActive) {
        return nil;
    }
    
    // Deselect the cell currently selected
    if (self.selectedQuestionCell) {
        [self.selectedQuestionCell setAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectedQuestionCell:nil];
    }
    
    // Acquire the cell upon which the client clicked.
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
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
    
    // Add a spinner to the cell as an indication that something's going on.
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell setAccessoryView: spinner];
    [self setSelectedQuestionCell:cell];
    
    [spinner startAnimating];
    
    return indexPath;
}

-(void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if ([segue.identifier isEqualToString:self.nextSegueIdentifier] &&
        [segue.destinationViewController isKindOfClass:[self class]]) {
      
        STRiskQuestionViewController *riskController = segue.destinationViewController;
        riskController.questionIndex = self.questionIndex + 1;
        
    } else if ([segue.identifier isEqualToString:self.previousSegueIdentifier] &&
               [segue.destinationViewController isKindOfClass:[self class]]) {
        
        STRiskQuestionViewController *riskController = segue.destinationViewController;
        riskController.questionIndex = self.questionIndex - 1;
        
    }
}

@end
