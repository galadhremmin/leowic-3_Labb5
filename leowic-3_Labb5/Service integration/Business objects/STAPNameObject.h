//
//  STAPNameObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 08/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPNameObject : NSObject

@property (nonatomic, copy) NSString *givenName;
@property (nonatomic, copy) NSString *surname;

-(id) initWithGivenName: (NSString *)givenName surname: (NSString *)surname;
-(NSString *) fullName;

@end
