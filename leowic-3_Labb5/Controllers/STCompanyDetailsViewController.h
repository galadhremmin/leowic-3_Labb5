//
//  STCompanyDetailsViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface STCompanyDetailsViewController : UITableViewController<CPTPieChartDataSource, CPTPlotDataSource>

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *financialManagementLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *distributionChartView;

@end

