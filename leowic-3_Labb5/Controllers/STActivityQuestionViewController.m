//
//  STActivityQuestionViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STActivityQuestionViewController.h"
#import "STAdviceStepViewController.h"
#import "STActivityLevelEnum.h"

@interface STActivityQuestionViewController ()

@property (nonatomic, strong) UIViewController *waitDialogue;

-(void) handleRiskProfile: (NSNumber *)calculatedRiskTendency;
-(void) handleRecommendationCompleted: (id)noop;
-(void (^)(void)) moveToAdviceBlock;

@end

@implementation STActivityQuestionViewController

-(void) viewWillAppear: (BOOL)animated
{
    if (!self.waitDialogue) {
        [self.coordinator registerSelector:@selector(handleRiskProfile:) onDelegate:self forSignal:STAPIUpdateRiskProfile];
        
        [self.coordinator registerSelector:@selector(handleRecommendationCompleted:) onDelegate:self forSignal:STAPIInitializeRecommendationSteps];
        
        [super viewWillAppear:animated];
    }
}

-(void) viewWillDisappear: (BOOL)animated
{
    if (!self.waitDialogue) {
        [super viewWillDisappear:animated];
    }
}

-(void) handleRiskProfile: (NSNumber *)calculatedRiskTendency
{
    // Present the "please wait" dialogue with an animation during the rather lenghty
    // initialization process.
    UIViewController *modalDialog = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"AdviceProcessingIdentifier"];
    modalDialog.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // Save the reference for later, so that we might close it when the initialization process
    // is complete
    [self setWaitDialogue:modalDialog];
    [self presentViewController:modalDialog animated:YES completion:NULL];
    
    // Now, instruct the web service to perform the initialization
    [self.coordinator.serviceProxy APIInitializeRecommendationSteps];
}

-(void) handleRecommendationCompleted: (id)noop
{
    // Close the modal dialogue and move on to the next step.
    if (![self.presentedViewController isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:[self moveToAdviceBlock]];
    }
    [self setWaitDialogue:nil];
}

-(void (^)(void)) moveToAdviceBlock
{
    return ^{
        [self performSegueWithIdentifier:@"AdviceStepSegue" sender:nil];
    };
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

-(void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if (![segue.identifier isEqualToString:@"AdviceStepSegue"]) {
        return;
    }
    
    STAdviceStepViewController *controller = (STAdviceStepViewController *)segue.destinationViewController;
    
    // First advice is always ITP, unless deliberately disabled, according to the API. As
    // this app doesn't support choosing what aspects of your pension you'd like to retrieve
    // information about, this behaviour is a fact.
    [controller setAdviceType:STAdviceTypeITP];
}

@end
