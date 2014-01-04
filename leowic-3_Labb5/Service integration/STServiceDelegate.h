//
//  STServiceDelegate.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STService.h"

@protocol STServiceDelegate <NSObject>

-(void) service: (STService *)service finishedMethod: (NSString *)method methodID: (NSUInteger)methodID withData: (NSDictionary *)jsonData;
-(void) service: (STService *)service failedWithError: (NSDictionary *)errorData;

-(void) addListener: (id)listener selector: (SEL)handler;
-(void) removeListener: (id)listener;

@end
