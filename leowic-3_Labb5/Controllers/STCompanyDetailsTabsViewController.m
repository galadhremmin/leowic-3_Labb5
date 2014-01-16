//
//  STCompanyDetailsTabsViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STCompanyDetailsTabsViewController.h"
#import "STFundsDetailsViewController.h"
#import "STModalViewController.h"

@implementation STCompanyDetailsTabsViewController

-(void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController addDismissButton:self];
    [self setTitle:self.company.name];
    
    // Find the tab bar item for the funds details view and enable or disable it
    // depending on the isTrad flag for the associated company.
    Class fundsControllerClass = [STFundsDetailsViewController class];
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:fundsControllerClass]) {
            [controller.tabBarItem setEnabled:!self.company.isTrad];
            break;
        }
    }
}

@end
