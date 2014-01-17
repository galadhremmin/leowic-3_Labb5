//
//  STAppearance.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 17/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAppearance.h"
#import "STSlideshowView.h"
#import "STTransparentCell.h"
#import "STTableView.h"

@implementation STAppearance

+(void) configureAppearance
{
    id appearance = [STSlideshowView appearance];
    [appearance setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"slideshow-background.png"]]];
    
    appearance = [UILabel appearance];
    [appearance setBackgroundColor:[UIColor clearColor]];
    
    appearance = [UILabel appearanceWhenContainedIn:[STSlideshowView class], nil];
    [appearance setColor:[UIColor blackColor]];
    
    appearance = [UILabel appearanceWhenContainedIn:[UITableViewCell class], nil];
    [appearance setColor:[UIColor blackColor]];
    
    appearance = [UITableView appearance];
    [appearance setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]];

    appearance = [UITableViewCell appearanceWhenContainedIn:[STTableView class], nil];
    [appearance setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-background.png"]]];
    [appearance setTintColor:[UIColor darkGrayColor]];
    
    appearance = [STTransparentCell appearanceWhenContainedIn:[STTableView class], nil];
    [appearance setBackgroundColor:[UIColor clearColor]];
}

@end
