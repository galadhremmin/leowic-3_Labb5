//
//  STAPIGetRecommendationStepHandler.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 14/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STAPIGetRecommendationStepHandler.h"
#import "STAPAdvice.h"
#import "STAPCompany.h"
#import "STAPFund.h"

@interface STAPIGetRecommendationStepHandler ()

-(void) populateAdvice: (STAPAdvice *)advice withData: (NSDictionary *)data;
-(void) populateAdvice: (STAPAdvice *)advice withCompanies: (NSArray *)dataForCompanies;
-(void) populateCompany: (STAPCompany *)company withData: (NSDictionary *)data;
-(void) populateCompany: (STAPCompany *)company withFunds: (NSArray *)dataForFunds;

@end

@implementation STAPIGetRecommendationStepHandler

-(id) handleResponseWithData: (NSDictionary *)responseData
{
    NSDictionary *root = [responseData objectForKey:@"GetRecommendationStepResult"];
    STAPAdvice *advice = [[STAPAdvice alloc] init];
    
    [self populateAdvice:advice withData:root];

    return advice;
}

-(void) populateAdvice: (STAPAdvice *)advice withData: (NSDictionary *)root
{
    [advice setFee:[[root objectForKey:@"Fee"] doubleValue]];
    
    id data = [root objectForKey:@"Companies"];
    [self populateAdvice:advice withCompanies:data];
}

-(void) populateAdvice: (STAPAdvice *)advice withCompanies: (NSArray *)dataForCompanies
{
    for (NSDictionary *companyData in dataForCompanies) {
        STAPCompany *company = [[STAPCompany alloc] init];
        
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
            
            for (STAPCompany *existingCompany in advice.companies) {
                if (existingCompany.ID == company.ID) {
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

-(void) populateCompany: (STAPCompany *)company withData: (NSDictionary *)root
{
    [company setShare:[[root objectForKey:@"Share"] unsignedIntegerValue]];
    
    if (!company.isTrad) {
        [self populateCompany:company withFunds:[root objectForKey:@"Funds"]];
    }
}

-(void) populateCompany: (STAPCompany *)company withFunds: (NSArray *)dataForFunds
{
    for (NSDictionary *fundData in dataForFunds) {
        STAPFund *fund = [[STAPFund alloc] init];
        
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