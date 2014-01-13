//
//  STGalleryViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 10/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface STGalleryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *galleryImageView;
@property (weak, nonatomic) IBOutlet UILabel *galleryTextBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *galleryCaptionLabel;

-(IBAction) startSessionButtonClicked: (UIBarButtonItem *)sender;

@end
