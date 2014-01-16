//
//  STService.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 02/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STServiceDelegate;
@class    STServiceCacheConfiguration;

@interface STService : NSObject<NSURLConnectionDelegate>

@property(nonatomic, strong) NSURL                       *URL;
@property(nonatomic, weak)   NSObject<STServiceDelegate> *delegate;
@property(atomic, readonly)  NSUInteger                   activeRequests;

-(id) initWithURL: (NSURL *)URL delegate: (NSObject<STServiceDelegate> *)delegate;

-(void) execute: (NSString *)method methodID: (NSUInteger)methodID arguments: (NSDictionary *)arguments cache: (BOOL)enableCache;

-(void) executeURLWithRawData: (NSURL *)url methodID: (NSUInteger)methodID;

-(void) clearCache;

@end
