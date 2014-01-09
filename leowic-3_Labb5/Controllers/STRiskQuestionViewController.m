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

@property(nonatomic) NSInteger                selectedQuestionIndex;
@property(nonatomic) UIActivityIndicatorView *spinnerView;

-(NSString *) previousSegueIdentifier;
-(NSString *) nextSegueIdentifier;
-(void) handleRiskProfile: (STAPRiskProfileObject *)riskProfile;

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
    [self setSelectedQuestionIndex:-1];
    
    STAPNotificationCoordinator *coordinator = [STAPNotificationCoordinator sharedCoordinator];
    [coordinator registerSelector:@selector(handleRiskProfile:) onDelegate:self forSignal:STAPIUpdateRiskProfile];
    [coordinator startCoordination];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [[STAPNotificationCoordinator sharedCoordinator] stopCoordination];
    
    if (self.spinnerView) {
        [self.spinnerView removeFromSuperview];
        [self setSpinnerView:nil];
    }
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

-(void) handleRiskProfile: (STAPRiskProfileObject *)riskProfile
{
    // Go to the next segue
    [self performSegueWithIdentifier:self.nextSegueIdentifier sender:nil];
}

-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    // If there's a spinner somewhere, something's loaded and further user interaction is disabled.
    if (self.spinnerView) {
        return nil;
    }
    
    // Acquire the cell upon which the client clicked.
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        return nil;
    }
    
    // Update the risk profile and notify the service proxy of this change.
    STAPNotificationCoordinator *coordinator = [STAPNotificationCoordinator sharedCoordinator];
    STAPRiskProfileObject *risk = coordinator.session.riskProfile;
    NSNumber *answer = [NSNumber numberWithInteger:indexPath.row];
    
    if (risk.riskQuestionAnswers.count <= self.questionIndex) {
        [risk addRiskQuestionAnswersObject:answer];
    } else {
        [risk replaceObjectInRiskQuestionAnswersAtIndex:self.questionIndex withObject:answer];
    }
    
    // Add a spinner to the cell as an indication that something's going on.
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell setAccessoryView: spinner];
    [self setSpinnerView:spinner];
    
    [spinner startAnimating];
    
    return indexPath;
}

-(BOOL) shouldPerformSegueWithIdentifier: (NSString *)identifier sender: (id)sender
{
    return self.selectedQuestionIndex >= 0;
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
