//
//  STRiskQuestionViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 04/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STRiskQuestionViewController.h"
#import "STNotificationCoordinator.h"
#import "STAPServiceProxy.h"

@interface STRiskQuestionViewController ()

@property(nonatomic, strong) STNotificationCoordinator *coordinator;
@property(nonatomic)         NSInteger                  selectedQuestionIndex;

@end

@implementation STRiskQuestionViewController

-(id) initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setQuestionIndex:0];
    }
    return self;
}

-(void) viewWillAppear: (BOOL)animated
{
    [self setSelectedQuestionIndex:-1];
    
    STAPServiceProxy *proxy = [STAPServiceProxy sharedProxy];
    STNotificationCoordinator *coordinator = [[STNotificationCoordinator alloc] initWithProxy:proxy context:self];
    [self.coordinator startCoordination];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [self.coordinator stopCoordination];
    [self setCoordinator:nil];
}

-(BOOL) shouldPerformSegueWithIdentifier: (NSString *)identifier sender: (id)sender
{
    return self.selectedQuestionIndex >= 0;
}

@end
