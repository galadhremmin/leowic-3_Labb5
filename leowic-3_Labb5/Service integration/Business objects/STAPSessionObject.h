//
//  STAPSession.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STAPGuideObject.h"

@interface STAPSessionObject : NSObject

@property (atomic, strong) STAPGuideObject *session;

@end
