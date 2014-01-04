//
//  STServiceConnection.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STServiceConnection : NSURLConnection

@property(nonatomic, readonly, strong) NSMutableData *receivedData;
@property(nonatomic, readonly, copy)   NSString      *methodName;
@property(nonatomic, readonly)         NSUInteger     methodID;

-(id) initWithRequest: (NSURLRequest *)request methodName: (NSString *)methodName methodID: (NSUInteger)methodID delegate: (id)delegate;

@end
