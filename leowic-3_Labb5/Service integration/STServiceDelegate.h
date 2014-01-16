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

@required
// Returns whether the service is currently in operation, like receiving data or waiting
// for a server response.
-(BOOL) isActive;

// A web service request was successfully executed. This method processes the data for
// the associated method.
-(void) service: (STService *)service finishedMethod: (NSString *)method methodID: (NSUInteger)methodID withData: (NSDictionary *)jsonData;

// A request of arbitrary nature was successfully executed for the specified method. The
// raw data is passed on to be dealt with. This method is invoked for all raw data requests.
-(void) service: (STService *)service finishedMethodID: (NSUInteger)methodID withRawData: (NSData *)data;

// A service request, data acquisition request or response handling failed.
-(void) service: (STService *)service failedWithError: (NSDictionary *)errorData;

@optional

// Adds a NSNotificationCenter listener to this  service's signals.
-(void) addListener: (id)listener selector: (SEL)handler;

// Removes a NSNotificationCenter listener to this  service's signals.
-(void) removeListener: (id)listener;

@end
