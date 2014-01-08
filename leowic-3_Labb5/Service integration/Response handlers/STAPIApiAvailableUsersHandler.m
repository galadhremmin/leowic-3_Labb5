//
//  STApiAvailableUsers.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPIApiAvailableUsersHandler.h"
#import "STAPTestUserObject.h"

@implementation STAPIApiAvailableUsersHandler

-(id) handleResponseWithData: (NSDictionary *)responseData
{
    NSMutableArray *users = [[NSMutableArray alloc] initWithCapacity:responseData.count];
    
    for (NSString *key in responseData.allKeys) {
        NSString *name = [responseData objectForKey:key];
        STAPTestUserObject *user = [[STAPTestUserObject alloc] initWithID:[key integerValue] name:name];
        
        [users addObject:user];
    }
    
    return users;
}

@end
