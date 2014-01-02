//
//  STMasterViewController.h
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 02/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface STMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
