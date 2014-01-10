//
//  STAPGalleryItemObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 10/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPGalleryItemObject : NSObject

@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *textBody;
@property (nonatomic, copy) NSString *illustrationPath;

-(id) initWithCaption: (NSString *)caption body: (NSString *)body illustrationPath: (NSString *)illustrationPath;

@end
