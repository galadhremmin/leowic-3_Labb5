//
//  STButton.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 17/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation STButton

-(id) initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"button-background.png"]]];
        [self setTintColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:2.0];
    }
    return self;
}

@end
