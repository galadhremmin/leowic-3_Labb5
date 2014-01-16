//
//  STAdviceStepViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCoordinatedTableViewController.h"
#import "STAdviceTypeEnum.h"

@interface STAdviceStepViewController : STCoordinatedTableViewController

@property (nonatomic) STAdviceTypeEnum adviceType;
@property (nonatomic) STAdviceTypeEnum nextAdviceType;

@end
