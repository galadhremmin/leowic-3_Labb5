//
//  STQuestionCell.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 17/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STTransparentCell.h"

@implementation STTransparentCell

-(void) addSubview: (UIView *)view
{
    // Hack! This prevents the separator view from being added to this view.
    NSString *className = NSStringFromClass([view class]);
    if ([className hasSuffix:@"UITableViewCellSeparatorView"]) {
        return;
    }
    
    [super addSubview:view];
}

@end
