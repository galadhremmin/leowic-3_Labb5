//
//  STCoordinatorItem.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 09/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCoordinatorItem : NSObject

@property (nonatomic, readonly)       SEL       selector;
@property (nonatomic, weak, readonly) NSObject *delegate;

-(id) initWithSelector: (SEL)selector delegate: (NSObject *)delegate;
-(BOOL) isEqual: (id)object;

@end
