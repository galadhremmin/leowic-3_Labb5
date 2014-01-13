//
//  STSingleChoiceViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 12/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STSingleChoiceViewController.h"

@interface STSingleChoiceViewController ()

@property (nonatomic) UITableViewCell *selectedQuestionCell;

@end

@implementation STSingleChoiceViewController

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator startCoordination];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [self.coordinator stopCoordination];
    
    if (self.selectedQuestionCell) {
        [self.selectedQuestionCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.selectedQuestionCell setAccessoryView:nil];
    }
    
    [super viewWillDisappear:animated];
}

-(STAPNotificationCoordinator *) coordinator
{
    return [STAPNotificationCoordinator sharedCoordinator];
}

-(NSIndexPath *) tableView: (UITableView *)tableView willSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    // If the service proxy is still handling requests, wait for it to finish before
    // enabling the client to move on.
    if (self.coordinator.serviceProxy.isActive) {
        return nil;
    }
    
    // Deselect the cell currently selected
    if (self.selectedQuestionCell) {
        [self.selectedQuestionCell setAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectedQuestionCell:nil];
    }
    
    // Acquire the cell upon which the client clicked.
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        return nil;
    }
    
    // Add a spinner to the cell as an indication that something's going on.
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell setAccessoryView: spinner];
    [self setSelectedQuestionCell:cell];
    
    [spinner startAnimating];
    
    return indexPath;
}

@end
