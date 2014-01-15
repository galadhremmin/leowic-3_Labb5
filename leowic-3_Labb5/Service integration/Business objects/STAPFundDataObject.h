//
//  STFundDataObject.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 15/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPFundDataObject : NSObject

@property (nonatomic, copy) NSString *ISINCode;
@property (nonatomic, copy) NSString *PPMCode;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic)       double    returnFirstMonth;
@property (nonatomic)       double    returnThreeMonths;
@property (nonatomic)       double    returnFirstYear;
@property (nonatomic)       double    returnThreeYears;
@property (nonatomic)       double    returnFiveYears;

@end
