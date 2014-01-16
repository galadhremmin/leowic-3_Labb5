//
//  STModalViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 16/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STModalViewController : UINavigationController<UINavigationControllerDelegate>

-(UIViewController *) initialViewController;

@end

@interface UINavigationController (STModalExtension)

-(void) addDismissButton: (UIViewController *)controller;

@end