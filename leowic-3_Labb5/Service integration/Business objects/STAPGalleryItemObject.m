//
//  STAPGalleryItemObject.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 10/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPGalleryItemObject.h"

@implementation STAPGalleryItemObject

-(id) initWithCaption: (NSString *)caption body: (NSString *)body illustrationPath: (NSString *)illustrationPath
{
    self = [super init];
    if (self) {
        [self setCaption:caption];
        [self setTextBody:body];
        [self setIllustrationPath:illustrationPath];
    }
    return self;
}

@end
