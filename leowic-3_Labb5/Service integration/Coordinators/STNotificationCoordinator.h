//
//  STNotificationProxy.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STServiceDelegate.h"

@interface STNotificationCoordinator : NSObject

@property(nonatomic, strong) NSObject<STServiceDelegate> *proxy;
@property(nonatomic)         BOOL                         isCoordinating;

-(id) initWithProxy: (NSObject<STServiceDelegate> *)proxy;

-(void) registerSelector: (SEL)selector onDelegate: (NSObject *)delegate forSignal: (NSUInteger)signal;
-(void) registerSelector: (SEL)selector onDelegate: (NSObject *)delegate forSignal: (NSUInteger)signal inferredPosition: (NSUInteger)inferredPosition;
-(void) removeAllSelectors;
-(void) clearState;

-(void) startCoordination;
-(void) stopCoordination;

-(BOOL) handleNotification: (NSNotification *)notification;
-(BOOL) signal: (NSNumber *)methodID withData: (id)data;

@end
