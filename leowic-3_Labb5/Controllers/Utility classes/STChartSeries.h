//
//  STChartSeries.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface STChartSeries : NSObject

@property (nonatomic)         NSNumber *dataValue;
@property (nonatomic, copy)   NSString *dataLegend;
@property (nonatomic, strong) CPTFill  *fillStyle;

-(id) initWithLegend: (NSString *)legend value: (double)value fillStyle: (CPTFill *)fill;

@end
