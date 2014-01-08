//
//  STAPNotificationCoordinator.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 05/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPNotificationCoordinator.h"
#import "STAPGuideObject.h"

@interface STAPNotificationCoordinator ()

@property (nonatomic)      BOOL             establishGuideSession;
@property (atomic, strong) STAPGuideObject *guideSession;

@end

@implementation STAPNotificationCoordinator

-(id) initWithProxy: (STAPServiceProxy *)proxy context: (id)selectorContext sessionCompulsory: (BOOL)establishGuideSession
{
    self = [super initWithProxy:proxy context:selectorContext];
    if (self) {
        [self setEstablishGuideSession:establishGuideSession];
    }
    return self;
}

-(void) startCoordination
{
    [super startCoordination];
    
    if (self.establishGuideSession) {
        [(STAPServiceProxy *)self.proxy APICreateGuideSession];
    }
}

@end
