//
//  STAPIApiAuthenticateHandler.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 03/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPIApiAuthenticateHandler.h"

@implementation STAPIApiAuthenticateHandler

-(id) handleResponseWithData: (NSDictionary *)responseData
{
    BOOL success = [[responseData objectForKey:@"ApiAuthenticateResult"] boolValue];
    return [NSNumber numberWithBool:success];
}

@end
