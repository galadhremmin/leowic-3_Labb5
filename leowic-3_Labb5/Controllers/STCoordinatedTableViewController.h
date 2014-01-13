//
//  STCoordinatedTableViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAPNotificationCoordinator.h"

@interface STCoordinatedTableViewController : UITableViewController

-(STAPNotificationCoordinator *) coordinator;
-(void) viewWillAppear: (BOOL)animated;
-(void) viewWillDisappear: (BOOL)animated;

@end
