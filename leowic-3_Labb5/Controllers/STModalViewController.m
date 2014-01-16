//
//  STModalViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 16/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STModalViewController.h"

@implementation STModalViewController

-(UIViewController *) initialViewController
{
    return [self.viewControllers firstObject];
}

@end

@implementation UINavigationController (STModalExtension)

-(void) addDismissButton: (UIViewController *)controller
{
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModality:)];
    
    controller.navigationItem.rightBarButtonItem = closeButton;
}

-(IBAction) dismissModality: (id)sender
{
    if (![self.presentedViewController isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
