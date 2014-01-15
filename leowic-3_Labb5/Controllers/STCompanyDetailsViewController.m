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
        
    }
    
    [self setDataSource:data];
}

-(void) configurePieChart
{
    // Create and initialise graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.distributionChartView.bounds];
	self.distributionChartView.hostedGraph = graph;
    
	graph.paddingLeft = 0.0f;
	graph.paddingTop = 0.0f;
	graph.paddingRight = 0.0f;
	graph.paddingBottom = 0.0f;
	graph.axisSet = nil;
    
	// Set up text style
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color = [CPTColor grayColor];
	textStyle.fontName = @"Helvetica";
	textStyle.fontSize = 15.0f;
	
    // Configure title
    /*
	NSString *title = @"Portfolio Prices: May 1, 2012";
	graph.title = title;
	graph.titleTextStyle = textStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    */
    
	// Set theme
	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
	[graph applyTheme:theme];
    
    // Create a pie chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
	pieChart.dataSource = self;
	pieChart.delegate = self;
	pieChart.pieRadius = (self.distributionChartView.bounds.size.height * 0.5) / 2;
	pieChart.identifier = graph.title;
	pieChart.startAngle = M_PI_4;
	pieChart.sliceDirection = CPTPieDirectionClockwise;
    
	// Add pie  to graph
	[graph addPlot:pieChart];
    
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    CPTMutableTextStyle *legendStyle = [[CPTMutableTextStyle alloc] init];
    legendStyle.fontSize = 13;
    
	// Configure legend
    theLegend.textStyle = legendStyle;
	theLegend.numberOfColumns = self.dataSource.count;
    
	// Add legend to graph
	graph.legend = theLegend;
	graph.legendAnchor = CPTRectAnchorBottomLeft;
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

