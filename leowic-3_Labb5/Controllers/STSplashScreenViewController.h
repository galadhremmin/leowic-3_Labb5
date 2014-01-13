//
//  STSplashScreenViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface STSplashScreenViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField  *APISecurityKeyField;
@property (weak, nonatomic) IBOutlet UIPickerView *APITestUserPicker;
@property (weak, nonatomic) IBOutlet UIButton     *APITestButton;

-(IBAction) performAuthenticationTest: (UIButton *)sender;

@end
