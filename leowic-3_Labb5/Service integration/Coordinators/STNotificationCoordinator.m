//
//  STNotificationProxy.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STNotificationCoordinator.h"
#import "STServiceDelegate.h"
#import "STCoordinatorItem.h"

@interface STNotificationCoordinator ()

@property(nonatomic, strong) NSMutableDictionary *signalSelectors;
@property(nonatomic, weak)   id                   context;

@end

@implementation STNotificationCoordinator

-(id) initWithProxy: (NSObject<STServiceDelegate> *)proxy
{
    self = [super init];
    if (self) {
        [self setProxy:proxy];
        [self setSignalSelectors:[[NSMutableDictionary alloc] init]];
    }
    return self;
}

-(void) dealloc
{
    [self stopCoordination];
}

-(void) registerSelector: (SEL)selector onDelegate: (NSObject *)delegate forSignal: (NSUInteger)signal
{
    if (self.isCoordinating) {
        [NSException raise:@"The coordinator cannot be changed while running." format:@"Disable coordination in order to add more selectors. "];
    }
    NSString *key = [NSString stringWithFormat:@"%d", signal];
    NSMutableArray *selectors = [self.signalSelectors objectForKey:key];
    
    if (selectors == nil) {
        selectors = [[NSMutableArray alloc] init];
    }
    
    STCoordinatorItem *item = [[STCoordinatorItem alloc] initWithSelector:selector delegate:delegate];
    
    if (![selectors containsObject:item]) {
        [selectors addObject:item];
        [self.signalSelectors setObject:selectors forKey:key];
    }
}

-(void) removeAllSelectors
{
    [self.signalSelectors removeAllObjects];
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
    
    id       methodID    = [[notificationData objectForKey:@"methodID"] stringValue];
    id       data        = [notificationData objectForKey:@"data"];
    NSArray *selectors   = [self.signalSelectors objectForKey:methodID];
    
    if (selectors == nil) {
        NSLog(@"STSplashScreenViewController: Unsupported signal %@.", methodID);
        return NO;
    }
    
    for (STCoordinatorItem *item in selectors) {
        [item.delegate performSelector:item.selector withObject:data afterDelay:0];
    }
    
    return YES;
}

@end
