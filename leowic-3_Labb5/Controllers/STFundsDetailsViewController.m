//
//  STFundsDetailsViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STFundsDetailsViewController.h"
#import "STCompanyDetailsTabsViewController.h"
#import "STFundDetailsViewController.h"
#import "STAPFundObject.h"

@interface STFundsDetailsViewController ()

-(STCompanyDetailsTabsViewController *) parentController;

@end

@implementation STFundsDetailsViewController

-(STCompanyDetailsTabsViewController *) parentController
{
    return (STCompanyDetailsTabsViewController *) self.tabBarController;
}

-(UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    STAPFundObject *fund = [self.parentController.company.funds objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundCell"];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%d %%", fund.share]];
    [cell.detailTextLabel setText:fund.name];
    
    return cell;
}

-(NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return self.parentController.company.funds.count;
}

-(NSString *) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    return NSLocalizedString(@"Recommended funds", nil);
}

-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    return nil;
}

-(void) tableView: (UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
    STAPFundObject *fund = self.parentController.company.funds[indexPath.row];
    [self performSegueWithIdentifier:@"FundDetailsSegue" sender:fund];
}

-(void) prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if ([segue.identifier isEqualToString:@"FundDetailsSegue"]) {
        STFundDetailsViewController *fundDetails = (STFundDetailsViewController *)segue.destinationViewController;
        
        [fundDetails setFund:sender];
    }
}

@end
