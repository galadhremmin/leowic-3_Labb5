//
//  STCacheItem.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 07/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCacheItem : NSObject

@property(nonatomic, strong) id          data;
@property(nonatomic, strong) NSDate     *dateAdded;
@property(nonatomic)         NSUInteger  hash;

-(id) initWithData: (id)data hash: (NSUInteger)hash;

@end
