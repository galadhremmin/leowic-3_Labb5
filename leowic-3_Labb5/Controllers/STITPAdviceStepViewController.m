//
//  STAdviceStepViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STITPAdviceStepViewController.h"
#import "STCompanyDetailsTabsViewController.h"
#import "STModalViewController.h"
#import "STAPAdviceObject.h"
#import "STAPCompanyObject.h"
#import "STAPFundObject.h"
#import "STFundCell.h"

@interface STITPAdviceStepViewController ()

@property (nonatomic, strong) STAPAdviceObject *advice;

-(void) handleAdviceData: (id)data;

@end

@implementation STITPAdviceStepViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    // Load the table header view
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ITPHeaderView" owner:self options:nil] firstObject];
    self.tableView.tableHeaderView = headerView;
}

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator registerSelector:@selector(handleAdviceData:) onDelegate:self forSignal:STAPIRecommendationStep];
    
    [super viewWillAppear:animated];
    
    [self.coordinator.serviceProxy APIGetRecommendationStep:STAdviceTypeITP];
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
}

@end
