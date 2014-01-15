//
//  STAPIGetRecommendationStepHandler.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 14/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPIGetRecommendationStepHandler.h"
#import "STAPAdviceObject.h"
#import "STAPCompanyObject.h"
#import "STAPFundObject.h"

@interface STAPIGetRecommendationStepHandler ()

-(void) populateAdvice: (STAPAdviceObject *)advice withData: (NSDictionary *)data;
-(void) populateAdvice: (STAPAdviceObject *)advice withCompanies: (NSArray *)dataForCompanies;
-(void) populateCompany: (STAPCompanyObject *)company withData: (NSDictionary *)data;
-(void) populateCompany: (STAPCompanyObject *)company withFunds: (NSArray *)dataForFunds;
-(void) populateCompany: (STAPCompanyObject *)company withTradData: (NSDictionary *)data;

@end

@implementation STAPIGetRecommendationStepHandler

-(id) handleResponseWithData: (NSDictionary *)responseData
{
    NSDictionary *root = [responseData objectForKey:@"GetRecommendationStepResult"];
    STAPAdviceObject *advice = [[STAPAdviceObject alloc] init];
    
    [self populateAdvice:advice withData:root];

    return advice;
}

-(void) populateAdvice: (STAPAdviceObject *)advice withData: (NSDictionary *)root
{
    [advice setFee:[[root objectForKey:@"Fee"] doubleValue]];
    
    id data = [root objectForKey:@"Companies"];
    [self populateAdvice:advice withCompanies:data];
}

-(void) populateAdvice: (STAPAdviceObject *)advice withCompanies: (NSArray *)dataForCompanies
{
    for (NSDictionary *companyData in dataForCompanies) {
        STAPCompanyObject *company = [[STAPCompanyObject alloc] init];
        
        [company setID:[[companyData objectForKey:@"CompanyID"] integerValue]];
        [company setName:[companyData objectForKey:@"CompanyName"]];
        [company setFee:[[companyData objectForKey:@"Fee"] doubleValue]];
        [company setIsTrad:[[companyData objectForKey:@"IsTrad"] boolValue]];
        [company setKapitaldelID:[[companyData objectForKey:@"KapitaldelID"] integerValue]];
        [company setProductID:[[companyData objectForKey:@"ProductId"] integerValue]]; // Heh! A discrepancy in the API! Whops! :)
        
        [self populateCompany:company withData:[companyData objectForKey:@"Data"]];
        
        // For ITP 1, the API always returns three sections (50 %, 25 % and 25 %). Merge these
        // sections, if the company choices are the same.
        if (advice.companies.count) {
            
            for (STAPCompanyObject *existingCompany in advice.companies) {
                if (existingCompany.ID == company.ID &&
                    existingCompany.isTrad == company.isTrad) { // must check due to AMF
                    // add the company's share to the existing one. Don't worry about the funds
                    // as these will always be identical across the company sections.
                    existingCompany.share += company.share;
                    company = nil; // Deallocate the company, and use the existing one instead
                    break;
                }
            }
        }
        
        if (company) {
            [advice.companies addObject:company];
        }
    }
}

-(void) populateCompany: (STAPCompanyObject *)company withData: (NSDictionary *)root
{
    [company setShare:[[root objectForKey:@"Share"] unsignedIntegerValue]];
    
    if (!company.isTrad) {
        [self populateCompany:company withFunds:[root objectForKey:@"Funds"]];
    } else {
        [self populateCompany:company withTradData:root];
    }
}

-(void) populateCompany: (STAPCompanyObject *)company withTradData: (NSDictionary *)data
{
    // Round to two decimals by multiplying with 100 (2 positions), rounding the result, and
    // dividing with 100 thereafter. MAX is used here as undefined is -1 according to the
    // API.
    double interest = round(100 * MAX([[data objectForKey:@"DistributionInterest"] doubleValue], 0)) * 0.01;
    double shares = round(100 * MAX([[data objectForKey:@"DistributionShares"] doubleValue], 0)) * 0.01;
    double property = round(100 * MAX([[data objectForKey:@"DistributionProperty"] doubleValue], 0)) * 0.01;
    
    // This is a rough estimation! But it's satisfactory for the purpose of this app.
    double other = 1 - interest - shares - property;
    
    STAPTradAllocationObject *allocation = [[STAPTradAllocationObject alloc] initWithInterest:interest shares:shares property:property other:other];
    
    [company setAllocation:allocation];
}

-(void) populateCompany: (STAPCompanyObject *)company withFunds: (NSArray *)dataForFunds
{
    for (NSDictionary *fundData in dataForFunds) {
        STAPFundObject *fund = [[STAPFundObject alloc] init];
        
        [fund setID:[[fundData objectForKey:@"FundID"] integerValue]];
        [fund setGroupID:[[fundData objectForKey:@"GroupID"] integerValue]];
        [fund setFundGroupID:[[fundData objectForKey:@"FundGroupID"] integerValue]];
        [fund setRating:[[fundData objectForKey:@"Rating"] unsignedIntegerValue]];
        [fund setShare:[[fundData objectForKey:@"Share"] unsignedIntegerValue]];
        [fund setName:[fundData objectForKey:@"Name"]];
        [fund setFee:[[fundData objectForKey:@"Fee"] doubleValue]];
        
        [company.funds addObject:fund];
    }
}

@end
