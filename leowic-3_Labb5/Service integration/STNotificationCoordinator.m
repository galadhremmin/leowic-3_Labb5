//
//  STNotificationProxy.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STNotificationCoordinator.h"
#import "STServiceDelegate.h"

@interface STNotificationCoordinator ()

@property(nonatomic, strong) NSMutableDictionary *signalSelectors;
@property(nonatomic, weak)   id                   context;

@end

@implementation STNotificationCoordinator

-(id) initWithProxy: (NSObject<STServiceDelegate> *)proxy context: (id)selectorContext
{
    self = [super init];
    if (self) {
        [self setProxy:proxy];
        [self setSignalSelectors:[[NSMutableDictionary alloc] init]];
        [self setContext:selectorContext];
    }
    return self;
}

-(void) dealloc
{
    [self stopCoordination];
}

-(void) registerSelector: (SEL)selector forSignal: (NSUInteger)signal
{
    if (self.isCoordinating) {
        [NSException raise:@"The coordinator cannot be changed while running." format:@"Disable coordination in order to add more selectors. "];
    }
    
    NSString *key = [NSString stringWithFormat:@"%d", signal];
    NSValue *value = [NSValue valueWithPointer:selector];
    
    [self.signalSelectors setObject:value forKey:key];
}

-(void) startCoordination
{
    if (!self.isCoordinating) {
        [self.proxy addListener:self selector:@selector(handleNotification:)];
    }

    [self setIsCoordinating:YES];
}

-(void) stopCoordination
{
    if (self.isCoordinating) {
        [self.proxy removeListener:self];
    }
    
    [self setIsCoordinating:NO];
}

-(BOOL) handleNotification: (NSNotification *)notification
{
    NSDictionary *notificationData = notification.userInfo;
    
    if ([notificationData objectForKey:@"error"] != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oj, något gick fel!" message:[notificationData objectForKey:@"localizedDescription"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    id methodID    = [[notificationData objectForKey:@"methodID"] stringValue];
    id data        = [notificationData objectForKey:@"data"];
    id methodValue = (NSValue *) [self.signalSelectors objectForKey:methodID];
    
    if (methodValue == nil) {
        NSLog(@"STSplashScreenViewController: Unsupported signal %@.", methodID);
        return NO;
    }
    
    SEL method;
    [methodValue getValue:&method];
    
    if (method == nil) {
        return NO;
    }
    
    [self.context performSelector:method withObject:data afterDelay:0];
    return YES;
}

@end
