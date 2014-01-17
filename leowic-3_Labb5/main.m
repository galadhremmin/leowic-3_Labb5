//
//  main.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 02/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUISettings.h"
#import "STAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        [NUISettings init];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([STAppDelegate class]));
    }
}
