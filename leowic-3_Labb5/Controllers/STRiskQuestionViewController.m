//
//  STRiskQuestionViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 04/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STRiskQuestionViewController.h"
#import "STAPNotificationCoordinator.h"
#import "STAPServiceProxy.h"

@interface STRiskQuestionViewController ()

@property(nonatomic, strong) STAPNotificationCoordinator *coordinator;
@property(nonatomic)         NSInteger                    selectedQuestionIndex;

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
    STAPNotificationCoordinator *coordinator = [[STAPNotificationCoordinator alloc] initWithProxy:proxy context:self establishGuideSession:YES];
    [self setCoordinator:coordinator];
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
