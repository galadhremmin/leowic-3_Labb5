//
//  STFundsDetailsViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STFundsDetailsViewController.h"
#import "STCompanyDetailsTabsViewController.h"

@interface STFundsDetailsViewController ()

-(STCompanyDetailsTabsViewController *) parentController;

@end

@implementation STFundsDetailsViewController

-(STCompanyDetailsTabsViewController *) parentController
{
    return (STCompanyDetailsTabsViewController *) self.tabBarController;
}

-(void) viewDidLoad
{
    
}

@end
