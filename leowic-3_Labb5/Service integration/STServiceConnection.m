//
//  STServiceConnection.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STServiceConnection.h"

@interface STServiceConnection ()

@property(nonatomic, strong) STServiceCacheConfiguration *cacheConfiguration;
@property(nonatomic, strong) NSMutableData               *receivedData;
@property(nonatomic, copy)   NSString                    *methodName;
@property(nonatomic)         NSUInteger                   methodID;

@end

@implementation STServiceConnection

-(id) initWithRequest: (NSURLRequest *)request methodName: (NSString *)methodName methodID: (NSUInteger)methodID cache: (STServiceCacheConfiguration *)cacheConfiguration delegate: (id)delegate
{
    self = [super initWithRequest:request delegate:delegate startImmediately:NO];
    if (self) {
        [self setMethodName:methodName];
        [self setMethodID:methodID];
        [self setCacheConfiguration:cacheConfiguration];
        [self setReceivedData:[[NSMutableData alloc] init]];
    }
    return self;
}

@end
