//
//  STAPAdvice.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 13/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPAdvice : NSObject

@property (nonatomic)         double          fee;
@property (nonatomic, strong) NSMutableArray *companies;

-(id) init;

@end
