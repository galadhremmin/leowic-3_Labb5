//
//  STSummaryViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 16/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSummaryViewController : UIViewController<UIDocumentInteractionControllerDelegate>

@property (nonatomic, weak) UIViewController *parentController;

-(IBAction) displayAdviceSummary: (UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *displayAdviceSummaryButton;
-(IBAction) startOver: (UIButton *)sender;


@end
