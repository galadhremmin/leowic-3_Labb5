//
//  STAdviceStepViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAdviceStepViewController.h"
#import "STAPAdvice.h"
#import "STAPCompany.h"
#import "STAPFund.h"

@interface STAdviceStepViewController ()

@property (nonatomic, strong) STAPAdvice *advice;

-(void) handleAdviceData: (id)data;

@end

@implementation STAdviceStepViewController

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator registerSelector:@selector(handleAdviceData:) onDelegate:self forSignal:STAPIRecommendationStep];
    
    [super viewWillAppear:animated];
    
    [self.coordinator.serviceProxy APIGetRecommendationStep:self.adviceType];
}

-(void) handleAdviceData: (STAPAdvice *)adviceData
{
    if (!adviceData) {
        return;
    }
    
    [self setAdvice:adviceData];
    [(UITableView *)self.view reloadData];
}

-(UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    STAPCompany *company = [self.advice.companies objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:company.isTrad
                             ? @"TradCell" : @"FundCell"];
    
    if (company.isTrad) {
        
        [cell.textLabel setText:@"Traditionell"];
        
    } else {
        
        STAPFund *fund = [company.funds objectAtIndex:indexPath.row];
        [cell.textLabel setText:fund.name];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d %%", fund.share]];
        
    }
    
    return cell;
}

-(NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return self.advice.companies.count;
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    STAPCompany *company = [self.advice.companies objectAtIndex:section];
    if (company.isTrad) {
        return 1;
    }
    
    return company.funds.count;
}

-(NSString *) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    STAPCompany *company = [self.advice.companies objectAtIndex:section];
    NSString *title = [NSString stringWithFormat:@"%d %% %@", company.share, company.name];
    return title;
}

-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    
    
    return nil;
}

@end
