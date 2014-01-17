//
//  STFundDetailsViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAPFundObject.h"
#import "CorePlot-CocoaTouch.h"

@interface STFundDetailsViewController : UITableViewController<CPTPlotDataSource, CPTBarPlotDataSource>

@property (nonatomic, weak) STAPFundObject *fund;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fundGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *morningstarRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *chartingView;

@property (weak, nonatomic) IBOutlet UITableViewCell *ISINCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *PPMCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *currencyCell;

@property (weak, nonatomic) IBOutlet UILabel *performanceFirstMonth;
@property (weak, nonatomic) IBOutlet UILabel *performanceThreeMonths;
@property (weak, nonatomic) IBOutlet UILabel *performanceFirstYear;
@property (weak, nonatomic) IBOutlet UILabel *performanceThreeYears;
@property (weak, nonatomic) IBOutlet UILabel *performanceFiveYears;

@end
