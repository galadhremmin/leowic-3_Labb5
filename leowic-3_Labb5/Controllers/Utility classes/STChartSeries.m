//
//  STChartSeries.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STChartSeries.h"

@implementation STChartSeries

-(id) initWithLegend: (NSString *)legend value: (double)value fillStyle: (CPTFill *)fill
{
    self = [super init];
    if (self) {
        [self setDataLegend:legend];
        [self setDataValue:@(value)];
        [self setFillStyle:fill];
    }
    return self;
}

@end
