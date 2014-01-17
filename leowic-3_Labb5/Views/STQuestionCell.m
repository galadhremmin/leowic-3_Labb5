//
//  STQuestionCell.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 17/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STQuestionCell.h"

@implementation STQuestionCell

-(void) addSubview: (UIView *)view
{
    NSString *className = NSStringFromClass([view class]);
    if ([className hasSuffix:@"UITableViewCellSeparatorView"]) {
        return;
    }
    
    [super addSubview:view];
}

@end
