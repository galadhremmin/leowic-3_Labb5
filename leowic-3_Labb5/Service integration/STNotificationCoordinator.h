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

@property(nonatomic) BOOL isCoordinating;

-(id) initWithProxy: (NSObject<STServiceDelegate> *)proxy context: (id)selectorContext;
-(void) registerSelector: (SEL)selector forSignal: (NSUInteger)signal;

-(void) startCoordination;
-(void) stopCoordination;

@end
