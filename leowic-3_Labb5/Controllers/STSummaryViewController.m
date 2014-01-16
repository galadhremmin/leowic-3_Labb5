//
//  STSummaryViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 16/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STSummaryViewController.h"
#import "STAPNotificationCoordinator.h"
#import "STAPCompletedAdviceObject.h"

@interface STSummaryViewController ()

@property (nonatomic, strong) STAPCompletedAdviceObject       *advice;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

-(STAPNotificationCoordinator *) coordinator;

-(void) handleRecommendations: (id)data;
-(void) handleSessionCompletion: (STAPCompletedAdviceObject *)advice;
-(void) handleAdviceSummary: (NSData *)data;
-(void) openDocumentInteractionMenu: (NSURL *)fileURL;

@end

@implementation STSummaryViewController

-(STAPNotificationCoordinator *) coordinator
{
    return [STAPNotificationCoordinator sharedCoordinator];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self.displayAdviceSummaryButton setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

-(void) dealloc
{
    if (self.documentController) {
        NSURL *file = self.documentController.URL;
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:file error:&error];
        
        if (error) {
            NSLog(@"Failed to delete %@. Error description: %@", file.absoluteString, error.localizedDescription);
        }
    }
}

-(void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.coordinator registerSelector:@selector(handleRecommendations:) onDelegate:self forSignal:STAPIGetRecommendations];
    [self.coordinator registerSelector:@selector(handleSessionCompletion:) onDelegate:self forSignal:STAPICompleteGuideSession];
    [self.coordinator registerSelector:@selector(handleAdviceSummary:) onDelegate:self forSignal:STAPIGetAdviceSummary];
    [self.coordinator startCoordination];
    
    // Perform the last step necessary before it is permitted to complete the advice:
    // ask for general recommendations pertaining to the client's pension. These aren't
    // going to be shown in the app, but they will be part of the advice summary that
    // the user can choose to download.
    if (!self.advice) {
        [self.coordinator.serviceProxy APIGetRecommendations];
    }
}

-(void) viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.coordinator stopCoordination];
}

-(void) handleRecommendations: (id)data
{
    // All right, we've got our recommendations. Move on and tell the API to complete
    // the advice session.
    [self.coordinator.serviceProxy APICompleteGuideSession];
}

-(void) handleSessionCompletion: (STAPCompletedAdviceObject *)advice
{
    // Now that we've completed the advice session, save the completed advice as it's
    // ID is a necessary argument to the advice summary function.
    [self setAdvice:advice];
    [self.displayAdviceSummaryButton setEnabled:YES];
}

-(void) handleAdviceSummary: (NSData *)data
{
    NSString *tmpDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"ITP.pdf"];
    
    if ([data writeToFile:tmpFile atomically:NO]) {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:tmpFile isDirectory:NO];
        [self openDocumentInteractionMenu:url];
    }
}

-(IBAction) displayAdviceSummary: (UIButton *)sender
{
    if (!self.advice.adviceID) {
        return;
    }
    
    if (self.documentController) {
        [self openDocumentInteractionMenu:nil];
    } else {
        [self.coordinator.serviceProxy APIGetSummary:self.advice.adviceID];
        [self.displayAdviceSummaryButton setEnabled:NO];
    }
}

-(void) openDocumentInteractionMenu: (NSURL *)fileURL
{
    UIDocumentInteractionController *controller = self.documentController;
    
    if (!controller) {
        controller = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        controller.delegate = self;
        controller.UTI = @"com.adobe.pdf";
        
        [self setDocumentController:controller];
    }
    
    [self.displayAdviceSummaryButton setEnabled:YES];
    [controller presentPreviewAnimated:YES];
}

-(UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    return self;
}

-(IBAction) startOver: (UIButton *)sender
{
    [self setAdvice:nil];
    
    __weak UIViewController *parentController = self.parentController;
    [self dismissViewControllerAnimated:YES completion:^{
        [parentController.navigationController popToRootViewControllerAnimated:YES];
    }];
}
@end
