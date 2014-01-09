//
//  STAPNotificationCoordinator.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 05/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPNotificationCoordinator.h"
#import "STAPServiceProxy.h"
#import "STAPGuideObject.h"

@interface STAPNotificationCoordinator ()

@property (nonatomic, weak) id               delegate;
@property (atomic, strong)  STAPGuideObject *guideSession;

-(STAPServiceProxy *) serviceProxy;
-(void) handleGuideSession: (NSNotification *)notification;

@end

@implementation STAPNotificationCoordinator

+(STAPNotificationCoordinator *) sharedCoordinator
{
    static STAPNotificationCoordinator *instance = nil;
    if (!instance) {
        STAPServiceProxy *proxy = [STAPServiceProxy sharedProxy];
        instance = [[STAPNotificationCoordinator alloc] initWithProxy:proxy];
    }
    
    return instance;
}

-(STAPServiceProxy *) serviceProxy
{
    return (STAPServiceProxy *) self.proxy;
}

-(void) startCoordination
{
    [self registerSelector:@selector(handleGuideSession:) onDelegate:self forSignal:STAPIEstablishSession];
    
    [super startCoordination];
    
    // Force a create session request as the first enqueued request
    if (self.session == nil) {
        [self.serviceProxy APICreateGuideSession];
    }
}

-(void) stopCoordination
{
    [super stopCoordination];
    [self removeAllSelectors];
}

-(void) handleGuideSession: (STAPGuideObject *)session
{
    if (self.session) {
        [self.session removeObserver:self forKeyPath:@"riskProfile.riskQuestionAnswers"];
    }
    
    [session addObserver:self forKeyPath:@"riskProfile.riskQuestionAnswers" options:NSKeyValueObservingOptionNew context:NULL];
    [self setSession:session];
}

-(void) observeValueForKeyPath: (NSString *)keyPath ofObject: (id)object change: (NSDictionary *)change context: (void *)context
{
    if ([keyPath isEqualToString:@"riskProfile.riskQuestionAnswers"]) {
        [self.serviceProxy APIUpdateRiskProfile:self.session.riskProfile];
    }
}

@end
