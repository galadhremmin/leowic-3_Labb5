//
//  STAppearance.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 17/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAppearance.h"
#import "STSlideshowView.h"
#import "STQuestionCell.h"

@implementation STAppearance

+(void) configureAppearance
{
    id appearance = [STSlideshowView appearance];
    [appearance setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"slideshow-background.png"]]];
    
    appearance = [UILabel appearanceWhenContainedIn:[STSlideshowView class], nil];
    [appearance setColor:[UIColor blackColor]];
    
    appearance = [UILabel appearanceWhenContainedIn:[UITableViewCell class], nil];
    [appearance setColor:[UIColor blackColor]];
    
    appearance = [UITableView appearance];
    [appearance setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]];
    
    appearance = [UITableViewCell appearance];
    [appearance setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-background.png"]]];
    [appearance setTintColor:[UIColor darkGrayColor]];
    
    appearance = [STQuestionCell appearance];
    [appearance setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
}

@end
