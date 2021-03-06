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
@property (atomic, strong)  STAPGuideObject *session;

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

-(void) clearState
{
    [super clearState];
    
    if (self.session) {
        [self.session removeObserver:self forKeyPath:@"riskProfile.riskQuestionAnswers"];
        [self.session removeObserver:self forKeyPath:@"riskProfile.activity"];
    }
    
    [self setSession:nil];
}

-(void) startCoordination
{
    [self registerSelector:@selector(handleGuideSession:) onDelegate:self forSignal:STAPIEstablishSession inferredPosition:0];
    
    [super startCoordination];
    
    // Force a create session request as the first enqueued request
    if (!self.session) {
        [self.serviceProxy APICreateGuideSession];
    } else {
        [super signal:[NSNumber numberWithInteger:STAPIEstablishSession] withData:self.session];
    }
}

-(void) stopCoordination
{
    [super stopCoordination];
    [self removeAllSelectors];
}

-(void) handleGuideSession: (STAPGuideObject *)session
{
    [self clearState];
    [session addObserver:self forKeyPath:@"riskProfile.riskQuestionAnswers" options:NSKeyValueObservingOptionNew context:NULL];
    [session addObserver:self forKeyPath:@"riskProfile.activity" options:NSKeyValueObservingOptionNew context:NULL];
    [self setSession:session];
}

-(void) observeValueForKeyPath: (NSString *)keyPath ofObject: (id)object change: (NSDictionary *)change context: (void *)context
{
    if ([keyPath isEqualToString:@"riskProfile.riskQuestionAnswers"] ||
        [keyPath isEqualToString:@"riskProfile.activity"]) {
        [self.serviceProxy APIUpdateRiskProfile:self.session.riskProfile];
    }
}

@end
