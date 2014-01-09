//
//  STAPNotificationCoordinator.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 05/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STNotificationCoordinator.h"
#import "STAPServiceProxy.h"
#import "STAPGuideObject.h"

@interface STAPNotificationCoordinator : STNotificationCoordinator

+(STAPNotificationCoordinator *) sharedCoordinator;

@property (nonatomic, strong) STAPGuideObject *session;

-(STAPServiceProxy *) serviceProxy;

@end
