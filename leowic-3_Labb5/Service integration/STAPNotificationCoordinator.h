//
//  STAPNotificationCoordinator.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 05/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STNotificationCoordinator.h"
#import "STAPServiceProxy.h"

@interface STAPNotificationCoordinator : STNotificationCoordinator

-(id) initWithProxy: (STAPServiceProxy *)proxy context: (id)selectorContext sessionCompulsory: (BOOL)establishGuideSession;
-(void) startCoordination;

@end
