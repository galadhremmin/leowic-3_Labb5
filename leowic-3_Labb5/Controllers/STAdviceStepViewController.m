//
//  STAdviceStepViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAdviceStepViewController.h"
#import "STCompanyDetailsTabsViewController.h"
#import "STModalViewController.h"
#import "STSummaryViewController.h"
#import "STAPAdviceObject.h"
#import "STAPCompanyObject.h"
#import "STAPFundObject.h"
#import "STFundCell.h"

@interface STAdviceStepViewController ()

@property (nonatomic, strong) STAPAdviceObject *advice;

-(void) handleAdviceData: (id)data;

@end

@implementation STAdviceStepViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    NSString *nibName, *title, *nextTitle;
    switch (self.adviceType) {
        case STAdviceTypeITP:
            nibName = @"ITPHeaderView";
            title = NSLocalizedString(@"ITP", nil);
            nextTitle = NSLocalizedString(@"PPM", nil);
            
            // PPM after ITP. This is necessary as fribrev is technically in between
            // but these are not included/supported by this app due to time constraints.
            [self setNextAdviceType:STAdviceTypePPM];
            break;
        case STAdviceTypePPM:
            nibName = @"PPMHeaderView";
            title = NSLocalizedString(@"PPM", nil);
            nextTitle = NSLocalizedString(@"Finish advice", nil);
            
            // Set next advice type to an invalid value, which will inform the segue
            // button that the next step is meant to complete the advice and show the
            // summary.
            [self setNextAdviceType:STAdviceTypeCount];
            break;
        default:
            [NSException raise:@"Okänd rådtyp." format:@"Råd av typen %d stöds inte av denna app", self.adviceType];
    }
    
    [self setTitle:title];
    [self.navigationItem.rightBarButtonItem setTitle:nextTitle];
    
    // Load the table header view
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
    self.tableView.tableHeaderView = headerView;
}

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator registerSelector:@selector(handleAdviceData:) onDelegate:self forSignal:STAPIRecommendationStep];
    
    [super viewWillAppear:animated];
    
    if (!self.advice) {
        [self.coordinator.serviceProxy APIGetRecommendationStep:self.adviceType];
    }
}

-(void) handleAdviceData: (STAPAdviceObject *)adviceData
{
    if (!adviceData) {
        return;
    }
    
    [self setAdvice:adviceData];
    [self.tableView reloadData];
}

-(UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    STAPCompanyObject *company = [self.advice.companies objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyCell"];
    
    NSNumberFormatter *floatingPointFormatter = [[NSNumberFormatter alloc] init];
    floatingPointFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *detailedInformation = [NSString stringWithFormat:NSLocalizedString(@"%@ management fee", nil), [floatingPointFormatter stringFromNumber:[NSNumber numberWithDouble:company.fee]]];
    
    [cell.textLabel setText:company.name];
    [cell.detailTextLabel setText:detailedInformation];
    
    return cell;
}

-(NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return self.advice.companies.count;
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return 1;
}

-(NSString *) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    STAPCompanyObject *company = self.advice.companies[section];
    NSString *sectionHeader = [NSString stringWithFormat:@"%d %% %@", company.share, company.isTrad
                               ? NSLocalizedString(@"Traditional financial management", nil)
                               : NSLocalizedString(@"Fund management", nil) ];
    return sectionHeader;
}

-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    return nil;
}

-(void) tableView: (UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
    NSNumber *section = [NSNumber numberWithInteger:indexPath.section];
    [self performSegueWithIdentifier:@"DetailsSegue" sender:section];
}

-(void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if ([segue.identifier isEqualToString:@"DetailsSegue"]) {
        NSNumber *section = (NSNumber *)sender;
        STAPCompanyObject *company = self.advice.companies[[section integerValue]];
        
        id destination = (STCompanyDetailsTabsViewController *) [(STModalViewController *) [segue destinationViewController] initialViewController];
        [destination setCompany:company];
    }
    
    if ([segue.identifier isEqualToString:@"AdviceStepSegue"]) {
        id destination = (STAdviceStepViewController *) segue.destinationViewController;
        [destination setAdviceType:self.nextAdviceType];
    }
    
    if ([segue.identifier isEqualToString:@"AdviceSummarySegue"]) {
        id destination = (STSummaryViewController *) segue.destinationViewController;
        [destination setParentController:self];
    }
}

-(BOOL) shouldPerformSegueWithIdentifier: (NSString *)identifier sender: (id)sender
{
    BOOL OK = YES;
    
    if ([identifier isEqualToString:@"AdviceStepSegue"]) {
        OK =  self.nextAdviceType != STAdviceTypeCount;
        
        if (!OK) {
            // If the next advice type is invalid, assume that the user has review
            // all segments of the advice given, and is ready to move on to the
            // summary. It's a bit of a hack to execute this here.
            [self performSelector:@selector(performSegueWithIdentifier:sender:) withObject:@"AdviceSummarySegue" afterDelay:0.1];
        }
    }
    
    return OK;
}
@end
