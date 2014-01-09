//
//  STCoordinatorItem.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 09/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STCoordinatorItem.h"

@interface STCoordinatorItem ()

@property (nonatomic)       SEL       selector;
@property (nonatomic, weak) NSObject *delegate;

@end

@implementation STCoordinatorItem

-(id) initWithSelector: (SEL)selector delegate: (NSObject *)delegate
{
    self = [super init];
    if (self) {
        [self setSelector:selector];
        [self setDelegate:delegate];
    }
    return self;
}

-(BOOL) isEqual: (id)object
{
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    STCoordinatorItem *item = (STCoordinatorItem *) object;
    return item.selector == self.selector &&
           item.delegate == self.delegate;
}

@end
