//
//  STAPTestUser.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPTestUserObject : NSObject

@property (atomic)       NSUInteger  userID;
@property (atomic, copy) NSString   *name;

-(id) initWithID: (NSUInteger)userID name: (NSString *)name;

@end
