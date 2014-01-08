//
//  STSplashScreenViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STSplashScreenViewController.h"
#import "STAPServiceProxy.h"
#import "STAPNotificationCoordinator.h"
#import "STAPTestUserObject.h"

@interface STSplashScreenViewController ()

@property(nonatomic, strong) NSArray *testUsers;
@property(nonatomic, strong) STAPNotificationCoordinator *coordinator;

@end

@implementation STSplashScreenViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self.APISecurityKeyField setText:[STAPServiceProxy APIKey]];
}

-(void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    STAPServiceProxy *proxy = [STAPServiceProxy sharedProxy];
    STAPNotificationCoordinator *coordinator = [[STAPNotificationCoordinator alloc] initWithProxy:proxy context:self establishGuideSession:NO];
    
    [coordinator registerSelector:@selector(handleTestUsers:) forSignal:STAPIRequestLoginUsers];
    [coordinator registerSelector:@selector(handleAuthentication:) forSignal:STAPILoginUser];
    [coordinator startCoordination];
    
    [proxy APIRequestLoginUsers];
    
    [self setCoordinator:coordinator];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    [self.coordinator stopCoordination];
    [self setCoordinator:nil];
}

#pragma mark - Service integration
-(void) handleTestUsers: (id)users
{
    [self setTestUsers:users];
    [self.APITestUserPicker reloadAllComponents];
}

-(void) handleAuthentication: (id)result
{
    BOOL success = [result boolValue];
    if (success) {
        [self performSegueWithIdentifier:@"GuideSegue" sender:nil];
    } else {
        NSLog(@"failed!");
    }
}

#pragma mark - Interface actions
- (IBAction)performAuthenticationTest:(UIButton *)sender {
    NSUInteger selectedIndex =  [self.APITestUserPicker selectedRowInComponent:0];
    STAPTestUserObject *user = self.testUsers[selectedIndex];
    
    [[STAPServiceProxy sharedProxy] APILoginUser:user.userID];
}

#pragma mark - Text field delegation
-(BOOL) textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Test user data source
// returns the number of 'columns' to display.
-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
-(NSInteger) pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.testUsers count];
}

-(NSString *) pickerView: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent: (NSInteger)component
{
    STAPTestUserObject *user = (STAPTestUserObject *)self.testUsers[row];
    return user.name;
}
@end