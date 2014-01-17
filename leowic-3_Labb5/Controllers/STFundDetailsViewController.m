//
//  STFundDetailsViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STFundDetailsViewController.h"
#import "STAPNotificationCoordinator.h"
#import "STAPFundDataObject.h"
#import "STChartSeries.h"
#import "STModalViewController.h"

@interface STFundDetailsViewController ()

@property (nonatomic, strong) NSArray *dataSource;

-(STAPNotificationCoordinator *) coordinator;
-(void) handleFundData: (STAPFundDataObject *)fundData;
-(void) loadDataSet: (STAPFundDataObject *)fundData;
-(void) loadChart: (STAPFundDataObject *)fundData;
-(void) setPerformance: (double)performance toLabel: (UILabel *)label;

@end

@implementation STFundDetailsViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    STAPFundObject *fund = self.fund;
    
    // Assign the fund's name to the title as well as the name label.
    [self setTitle:fund.name];
    [self.nameLabel setText:fund.name];
    
    // Share (eg. 90 %)
    NSString *share = [NSString stringWithFormat:@"%d %%", fund.share];
    [self.shareLabel setText:share];
    
    // Morningstar rating expressed with stars ★
    NSMutableString *morningstars = [[NSMutableString alloc] initWithCapacity:fund.rating];
    for (NSUInteger i = 0; i < fund.rating; i += 1) {
        [morningstars appendString:@"★"];
    }
    [self.morningstarRatingLabel setText:morningstars];
    
    // Fund group / category
    NSString *groupIdentifier = [NSString stringWithFormat:@"Fund Group %d", fund.fundGroupID];
    [self.fundGroupLabel setText:NSLocalizedString(groupIdentifier, nil)];
    
    // Fee with usual formatting
    NSNumberFormatter *floatingPointFormatter = [[NSNumberFormatter alloc] init];
    floatingPointFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *feeText = [NSString stringWithFormat:@"%@ %%", [floatingPointFormatter stringFromNumber:@(fund.fee)]];
    [self.feeLabel setText:feeText];
    
    // Hide the cells whose data needs to be fetched from the web service
    [self.PPMCell.detailTextLabel setText:@"-"];
    [self.ISINCell.detailTextLabel setText:@"-"];
    [self.currencyCell.detailTextLabel setText:@"-"];
}

-(void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add the dismiss modal dialogue button ("done")
    [self.navigationController addDismissButton:self];
    
    [self.coordinator registerSelector:@selector(handleFundData:) onDelegate:self forSignal:STAPIGetFundData];
    [self.coordinator startCoordination];
    [self.coordinator.serviceProxy APIGetFundData:self.fund.ID];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.coordinator stopCoordination];
}

-(STAPNotificationCoordinator *) coordinator
{
    return [STAPNotificationCoordinator sharedCoordinator];
}

-(void) handleFundData: (STAPFundDataObject *)fundData
{
    if (self.ISINCell) {
        [self.ISINCell.detailTextLabel setText:fundData.ISINCode];
    }
    
    if (fundData.PPMCode) {
        [self.PPMCell.detailTextLabel setText:fundData.PPMCode];
    }
    
    if (fundData.currency) {
        [self.currencyCell.detailTextLabel setText:fundData.currency];
    }
    
    [self.tableView reloadData];
    [self performSelector:@selector(loadChart:) withObject:fundData afterDelay:1];
}

-(void) loadDataSet: (STAPFundDataObject *)fundData
{
    double red = 120, green = 196, blue = 235;
    
    STChartSeries *series;
    CPTFill *defaultFill = [[CPTFill alloc] initWithColor:[CPTColor colorWithComponentRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1]];
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:5];
    
    series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Return first month", nil)
                                             value:(fundData.returnFirstMonth - 1) * 100
                                         fillStyle:defaultFill];
    [data addObject:series];
    
    series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Return three months", nil)
                                             value:(fundData.returnThreeMonths - 1) * 100
                                         fillStyle:defaultFill];
    [data addObject:series];
    
    series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Return first year", nil)
                                             value:(fundData.returnFirstYear - 1) * 100
                                         fillStyle:defaultFill];
    [data addObject:series];
    
    series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Return three years", nil)
                                             value:(fundData.returnThreeYears - 1) * 100
                                         fillStyle:defaultFill];
    [data addObject:series];
    
    series = [[STChartSeries alloc] initWithLegend:NSLocalizedString(@"Return five years", nil)
                                             value:(fundData.returnFiveYears - 1) * 100
                                         fillStyle:defaultFill];
    [data addObject:series];
    
    [self setDataSource:data];
}

-(void) loadChart: (STAPFundDataObject *)fundData
{
    [self setPerformance:fundData.returnFirstMonth toLabel:self.performanceFirstMonth];
    [self setPerformance:fundData.returnThreeMonths toLabel:self.performanceThreeMonths];
    [self setPerformance:fundData.returnFirstYear toLabel:self.performanceFirstYear];
    [self setPerformance:fundData.returnThreeYears toLabel:self.performanceThreeYears];
    [self setPerformance:fundData.returnFiveYears toLabel:self.performanceFiveYears];
}

-(void) setPerformance: (double)performance toLabel: (UILabel *)label
{
    NSString *symbol;
    UIColor *color;
    
    if (performance > 0) {
        color = [UIColor colorWithRed:49/255.0 green:120/255.0 blue:115/255.0 alpha:1];
        symbol = @"▲";
    } else if (performance < 0) {
        color = [UIColor redColor];
        symbol = @"▼";
    } else {
        color = [UIColor grayColor];
        symbol = @"-";
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    
    NSString *labelText = [NSString stringWithFormat:@"%@ %@ %%", symbol, [formatter stringFromNumber:@(performance)]];
    
    [label setText:labelText];
    [label setTextColor:color];
}

#pragma mark - CPTBarChartDelegate methods

-(NSUInteger) numberOfRecordsForPlot: (CPTPlot *)plot
{
    return 1;
}

-(NSNumber *) numberForPlot: (CPTPlot *)plot field: (NSUInteger)fieldEnum recordIndex: (NSUInteger)index
{
    if (fieldEnum == CPTBarPlotFieldBarTip && index < self.dataSource.count) {
        for (STChartSeries *series in self.dataSource) {
            if ([series.dataLegend isEqualToString:(NSString *)plot.identifier]) {
                return [series dataValue];
            }
        }
    }
    
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

-(CPTFill *) barFillForBarPlot: (CPTBarPlot *)barPlot recordIndex: (NSUInteger)index
{
    return [self.dataSource[index] fillStyle];
}

@end
