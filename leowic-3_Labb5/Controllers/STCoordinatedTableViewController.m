//
//  STCoordinatedTableViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STCoordinatedTableViewController.h"

@implementation STCoordinatedTableViewController

-(STAPNotificationCoordinator *) coordinator
{
    return [STAPNotificationCoordinator sharedCoordinator];
}

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator startCoordination];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [self.coordinator stopCoordination];
}

@end
