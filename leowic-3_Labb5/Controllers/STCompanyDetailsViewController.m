//
//  STCompanyDetailsViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STCompanyDetailsViewController.h"
#import "STCompanyDetailsTabsViewController.h"
#import "STChartSeries.h"
#import "STAPFund.h"

@interface STCompanyDetailsViewController ()

@property (nonatomic, strong) NSArray *dataSource;

-(STCompanyDetailsTabsViewController *) parentController;
-(void) configureDataSource;
-(void) configurePieChart;

@end

@implementation STCompanyDetailsViewController

-(STCompanyDetailsTabsViewController *) parentController
{
    return (STCompanyDetailsTabsViewController *) self.tabBarController;
}

-(void) viewDidLoad
{
    STAPCompany *company = self.parentController.company;
    
    [self.companyNameLabel setText:company.name];
    [self.financialManagementLabel setText:company.isTrad ? NSLocalizedString(@"Traditional financial management", nil)
                                                          : NSLocalizedString(@"Fund management", nil) ];
    [self.shareLabel setText:[NSString stringWithFormat:@"%d %%", company.share]];
    
    // Format the floating point (fee) appropriately (according to the current locale)
    NSNumberFormatter *floatingPointFormatter = [[NSNumberFormatter alloc] init];
    floatingPointFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *feeText = [NSString stringWithFormat:@"%@ %%", [floatingPointFormatter stringFromNumber:[NSNumber numberWithDouble:company.fee]]];
    [self.feeLabel setText:feeText];
}

-(void) viewDidAppear: (BOOL)animated
{
    [self configureDataSource];
    [self configurePieChart];
}

-(void) configureDataSource
{
    STAPCompany *company = self.parentController.company;
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    if (company.isTrad) {
        STAPTradAllocationObject *allocation = company.allocation;
        CPTFill *fill;
        STChartSeries* series;
        
        if (allocation.distributionInterest > 0) {
            CPTColor *color = [CPTColor colorWithComponentRed:120/255.0 green:196/255.0 blue:235/255.0 alpha:1];
            fill = [[CPTFill alloc] initWithColor:color];
            series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Interest market", nil)
                                                     value:allocation.distributionInterest
                                                 fillStyle:fill];
            [data addObject:series];
        }
        
        if (allocation.distributionShares > 0) {
            CPTColor *color = [CPTColor colorWithComponentRed:238/255.0 green:109/255.0 blue:95/255.0 alpha:1];
            fill = [[CPTFill alloc] initWithColor:color];
            series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Stock market", nil)
                                                     value:allocation.distributionShares
                                                 fillStyle:fill];
            [data addObject:series];
        }
        
        if (allocation.distributionProperty > 0) {
            CPTColor *color = [CPTColor colorWithComponentRed:239/255.0 green:206/255.0 blue:104/255.0 alpha:1];
            fill = [[CPTFill alloc] initWithColor:color];
            series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Properties", nil)
                                                     value:allocation.distributionProperty
                                                 fillStyle:fill];
            [data addObject:series];
        }
        
        if (allocation.distributionOther > 0) {
            CPTColor *color = [CPTColor colorWithComponentRed:129/255.0 green:151/255.0 blue:127/255.0 alpha:1];
            fill = [[CPTFill alloc] initWithColor:color];
            series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Other markets", nil)
                                                     value:allocation.distributionOther
                                                 fillStyle:fill];
            [data addObject:series];
        }
        
    } else {
        double red = 120, green = 196, blue = 235;
        
        for (STAPFund *fund in company.funds) {
            NSString *groupIdentifier = [NSString stringWithFormat:@"Fund Group %d", fund.fundGroupID];
            NSString *group = NSLocalizedString(groupIdentifier, nil);
            
            STChartSeries *series = nil;
            for (STChartSeries *existingSeries in data) {
                if ([existingSeries.dataLegend isEqualToString:group]) {
                    series = existingSeries;
                    break;
                }
            }
            
            if (series) {
                NSNumber *newValue = @( [series.dataValue doubleValue] + fund.share * 0.01 );
                [series setDataValue:newValue];
            } else {
                CPTColor *color = [CPTColor colorWithComponentRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
                CPTFill *fill = [CPTFill fillWithColor:color];
                series = [[STChartSeries alloc] initWithLegend:group value:fund.share * 0.01 fillStyle:fill];
                
                // Increment colour brightness with 10 %. Cap to 255 obviously, as this is white.
                red   = MIN(red * 1.1, 255);
                green = MIN(green * 1.1, 255);
                blue  = MIN(blue * 1.1, 255);
                
                [data addObject:series];
            }
        }
        
    }
    
    [self setDataSource:data];
}

-(void) configurePieChart
{
    // Create and initialise the pie graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.distributionChartView.bounds];
	self.distributionChartView.hostedGraph = graph;
    
	graph.paddingLeft = 0;
	graph.paddingTop = 0;
	graph.paddingRight = 0;
	graph.paddingBottom = 0;
	graph.axisSet = nil;
    graph.borderLineStyle = nil;
    
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.borderWidth = 0;
    graph.plotAreaFrame.cornerRadius = 0;
    
    // Create a pie chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
	pieChart.dataSource = self;
	pieChart.delegate = self;
	pieChart.pieRadius = (self.distributionChartView.bounds.size.height * 0.5) / 2;
	pieChart.identifier = graph.title;
	pieChart.startAngle = M_PI_4;
	pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.borderLineStyle = nil;
    
	// Add pie  to graph
	[graph addPlot:pieChart];
    
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    CPTMutableTextStyle *legendStyle = [[CPTMutableTextStyle alloc] init];
    legendStyle.fontSize = 10;
    
	// Configure legend
    theLegend.borderLineStyle = nil;
    theLegend.textStyle = legendStyle;
	theLegend.numberOfColumns = self.dataSource.count;
    
	// Add legend to graph
	graph.legend = theLegend;
	graph.legendAnchor = CPTRectAnchorTop;
	graph.legendDisplacement = CGPointZero;
}

#pragma mark - CPTPlotDataSource methods

-(NSUInteger) numberOfRecordsForPlot: (CPTPlot *)plot
{
	return self.dataSource.count;
}

-(NSNumber *) numberForPlot: (CPTPlot *)plot field: (NSUInteger)fieldEnum recordIndex: (NSUInteger)index
{
	if (CPTPieChartFieldSliceWidth == fieldEnum) {
		return [self.dataSource[index] dataValue];
	}
    
	return [NSDecimalNumber zero];
}

-(CPTFill *) sliceFillForPieChart: (CPTPieChart *)pieChart recordIndex: (NSUInteger)index
{
    if (index < self.dataSource.count) {
        return [self.dataSource[index] fillStyle];
    }
    
    return nil;
}

-(CPTLayer *) dataLabelForPlot: (CPTPlot *)plot recordIndex: (NSUInteger)index
{
	// Define label text style
	static CPTMutableTextStyle *labelText = nil;
	if (!labelText) {
		labelText = [[CPTMutableTextStyle alloc] init];
		labelText.color = [CPTColor grayColor];
	}
	
	NSInteger value = (NSInteger)([[self.dataSource[index] dataValue] doubleValue] * 100);
	NSString *labelValue = [NSString stringWithFormat:@"%d %%", value];
	
	return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *) legendTitleForPieChart: (CPTPieChart *)pieChart recordIndex: (NSUInteger)index
{
	if (index < self.dataSource.count) {
		return [self.dataSource[index] dataLegend];
	}
    
	return @"N/A";
}

@end

