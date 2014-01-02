//
//  STDetailViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 02/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
