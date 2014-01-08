//
//  STAPNameObject.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPNameObject.h"

@implementation STAPNameObject

-(id) initWithGivenName: (NSString *)givenName surname: (NSString *)surname
{
    self = [super init];
    if (self) {
        [self setGivenName:givenName];
        [self setSurname:surname];
    }
    return self;
}

-(NSString *)fullName
{
    NSMutableString *fullName = [[NSMutableString alloc] initWithCapacity:self.givenName.length + 1 + self.surname.length];
    
    [fullName appendString:self.givenName];
    [fullName appendString:@" "];
    [fullName appendString:self.surname];
    
    return fullName;
}

@end
