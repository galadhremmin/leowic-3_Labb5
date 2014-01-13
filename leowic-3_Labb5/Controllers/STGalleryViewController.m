//
//  STGalleryViewController.m
//  leowic-3_Labb5
//
//  Created by Leonard Wickmark on 10/01/14.
//  Copyright (c) 2014 Softronic AB. All rights reserved.
//

#import "STGalleryViewController.h"
#import "STAPGalleryItemObject.h"
#import "STAPNotificationCoordinator.h"

@interface STGalleryViewController ()

@property (nonatomic, strong) NSArray   *galleryItems;
@property (nonatomic)         NSInteger  currentIndex;

-(STAPNotificationCoordinator *) coordinator;
-(void) handleSession: (STAPGuideObject *)session;
-(void) loadGalleryItems;
-(void) initAnimation;
-(void) beginAnimation;
-(void) animationFirstFrame;
-(void) animationLastFrame;

@end

@implementation STGalleryViewController

-(void) viewDidLoad
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"slideshow-background" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIColor *backgroundImage = [UIColor colorWithPatternImage:image];
    [self.view setBackgroundColor:backgroundImage];
}

-(void) viewWillAppear: (BOOL)animated
{
    [self.coordinator registerSelector:@selector(handleSession:) onDelegate:self forSignal:STAPIEstablishSession];
    [self.coordinator startCoordination];
    [self initAnimation];
}

-(void) viewWillDisappear: (BOOL)animated
{
    [self.coordinator stopCoordination];
}

-(STAPNotificationCoordinator *) coordinator
{
    return [STAPNotificationCoordinator sharedCoordinator];
}

-(void) handleSession: (STAPGuideObject *)session
{
    [self loadGalleryItems];
    [self beginAnimation];
}

-(void) loadGalleryItems
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Gallery Configuration" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (NSDictionary *textData in data) {
        STAPGalleryItemObject *item = [[STAPGalleryItemObject alloc] init];
        
        NSError *error;
        NSRegularExpression *tagReg = [NSRegularExpression regularExpressionWithPattern:@"\\{([a-zA-Z0-9\\.]+)\\}" options:0 error:&error];
        
        for (NSString *key in textData.allKeys) {
            NSMutableString *textBody = [NSMutableString stringWithString:[textData objectForKey:key]];
            NSArray *matches = [tagReg matchesInString:textBody options:0 range:NSMakeRange(0, textBody.length)];
            
            for (NSTextCheckingResult *match in matches) {
                NSString *keyPath = [textBody substringWithRange:[match rangeAtIndex:1]],
                         *value   = [self.coordinator.session valueForKeyPath:keyPath];
                
                [textBody replaceCharactersInRange:[match rangeAtIndex:0] withString:value];
            }
            
            [item setValue:textBody forKeyPath:key];
        }
        
        [items addObject:item];
    }
    
    [self setGalleryItems:items];
}

-(void) initAnimation
{
    [self setCurrentIndex:0];
    self.galleryCaptionLabel.layer.opacity = 0;
    self.galleryTextBodyLabel.layer.opacity = 0;
    self.galleryImageView.layer.opacity = 0;
}

-(void) beginAnimation
{
    [self animationLastFrame];
}

-(void) animationFirstFrame
{
    __weak UIView *captionLabel = self.galleryCaptionLabel,
                  *textBodyLabel = self.galleryTextBodyLabel,
                  *imageLabel = self.galleryImageView;
    
    __weak id weakSelf = self;
    
    if (self.currentIndex >= self.galleryItems.count) {
        return;
    }
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        captionLabel.layer.opacity = 0;
        textBodyLabel.layer.opacity = 0;
        imageLabel.layer.opacity = 0;
    } completion:^(BOOL finished){
        if (!finished) {
            return;
        }
        
        [weakSelf performSelector:@selector(animationLastFrame) withObject:nil afterDelay:0];
    }];
}

-(void) animationLastFrame
{
    __weak UIView *captionLabel = self.galleryCaptionLabel,
                  *textBodyLabel = self.galleryTextBodyLabel,
                  *imageLabel = self.galleryImageView;
    
    __weak id weakSelf = self;
    
    STAPGalleryItemObject *item = [self.galleryItems objectAtIndex:self.currentIndex];
    [self populateViewWithData:item];
    
    __block BOOL shouldSwitch = NO;
    self.currentIndex += 1;
    shouldSwitch = YES;
    
    [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        captionLabel.layer.opacity = 1;
        textBodyLabel.layer.opacity = 1;
        imageLabel.layer.opacity = 1;
    } completion:^(BOOL finished){
        if (!finished || !shouldSwitch) {
            return;
        }
        
        [weakSelf performSelector:@selector(animationFirstFrame) withObject:nil afterDelay:8.0];
    }];
}

-(void) populateViewWithData: (STAPGalleryItemObject *)item
{
    [self.galleryCaptionLabel setText:item.caption];
    [self.galleryTextBodyLabel setText:item.textBody];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:item.illustrationPath ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [self.galleryImageView setImage:image];
}

-(IBAction) startSessionButtonClicked: (UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"StartSessionSegue" sender:nil];
}
@end
