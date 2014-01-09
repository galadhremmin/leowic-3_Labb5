//
//  STAPService.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STServiceDelegate.h"
#import "STAPRiskProfileObject.h"

@interface STAPServiceProxy : NSObject<STServiceDelegate>

typedef enum {
    STAPIRequestLoginUsers = 1,
    STAPILoginUser,
    STAPIEstablishSession,
    STAPIUpdateRiskProfile
} STAPServiceMethod;

+(NSString *)         APIKey;
+(void)               setAPIKey: (NSString *)key;
+(STAPServiceProxy *) sharedProxy;

-(id)   init;

-(void) APIRequestLoginUsers;
-(void) APILoginUser: (int)userID;
-(void) APICreateGuideSession;
-(void) APIUpdateRiskProfile: (STAPRiskProfileObject *)riskProfile;

-(void) addListener: (id)listener selector: (SEL)handler;
-(void) removeListener: (id)listener;

@end
