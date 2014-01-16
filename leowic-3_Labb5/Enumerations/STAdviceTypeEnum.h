//
//  STAdviceTypeEnum.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 14/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  
    STAdviceTypeITP = 0,
    STAPAdviceFribrev,
    STAdviceTypePPM,
    
    // This is not an actual member, bur rather the number of different variants
    // there are.
    STAdviceTypeCount
    
} STAdviceTypeEnum;
