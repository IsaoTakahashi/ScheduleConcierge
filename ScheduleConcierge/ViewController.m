//
//  ViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/29.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "ViewController.h"
#import "GlobalProperty.h"
#import "NSDate+Softbuild.h"
#import "BookmarkDAO.h"
#import <GoogleMaps/GoogleMaps.h>

#define DateBarCount 3

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void) viewDidAppear:(BOOL)animated {
    DateBarViewController *barCtr;
    NSDate *date = [NSDate date];
    StickyManager *stickyMgr = [StickyManager getInstance];
    
    for (int i=0;i < DateBarCount; i++) {
        
        barCtr = [[DateBarViewController alloc] initWithNibName:@"DateBarViewController" bundle:nil];
        CGPoint origin = CGPointZero;
        origin.x = 50;
        origin.y += 30 * (i+1);
        origin.y += barCtr.view.frame.size.height * i;
        
        barCtr.view.frame = CGRectMake(origin.x, origin.y, barCtr.view.frame.size.width, barCtr.view.frame.size.height);
        [barCtr setDate:date];
        
        [self.view addSubview:barCtr.view];
        [stickyMgr addDateBar:barCtr];
        
        date = [date tommorow];
        NSLog(@"%f",[date timeIntervalSince1970]);
    }
    
    //initialize sticky(bookmark)
    NSMutableArray* bmArray = [BookmarkDAO selectAll];
    for(Bookmark *bm in bmArray) {
        [self registerStickyWithBookmark:bm];
    }

    self.edittedSticky = nil;
}

-(void)registerStickyWithBookmark:(Bookmark*)bm {
    StickyManager *stickyMgr = [StickyManager getInstance];
    UIStickyViewController *newStickyCtr = [[UIStickyViewController alloc] initWithNibName:@"UIStickyViewController" bundle:nil];
    UIStickyView *sticky = (UIStickyView*)newStickyCtr.view;
    sticky.delegate = self;
    [self.view addSubview:newStickyCtr.view];
    
    [stickyMgr addStickyWithBookmark:bm usvCtr:newStickyCtr];
}

-(void)showBookmarkSettingView:(Bookmark*)bm {
    bsViewCtr = [[BookmarkSettingViewController alloc] initWithNibName:@"BookmarkSettingViewController" bundle:nil];
    bsViewCtr.delegate = self;
    if(bm != nil) {
        [bsViewCtr refleshWithBookmark:bm];
    }
    
    CGRect window = [[UIScreen mainScreen] bounds];
    bsViewCtr.view.center = CGPointMake(window.size.height/2, window.size.width/3);
    [bsViewCtr.view setAlpha:0.1];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [bsViewCtr.view setAlpha:1.0];
    
    [UIView commitAnimations];
    
    [self.view addSubview:bsViewCtr.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer*)sender
{
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            if(sender.numberOfTouches > 0)
            {
                //NSLog(@"handled %@",NSStringFromCGPoint([sender locationOfTouch:0 inView:self.view]));
            }
            
            break;
        default:
            break;
            
    }
}

- (IBAction)clickStickyButton:(id)sender
{
    StickyManager *stickyMgr = [StickyManager getInstance];
    
    UIStickyViewController *newStickyCtr = [[UIStickyViewController alloc] initWithNibName:@"UIStickyViewController" bundle:nil];
    UIStickyView *sticky = (UIStickyView*)newStickyCtr.view;
    sticky.delegate = self;
    
    [self.view addSubview:newStickyCtr.view];
    
    [stickyMgr addSticky:newStickyCtr];
}

- (IBAction)clidkSpringButton:(UIButton*)sender {
    GlobalProperty *gp = [GlobalProperty getInstance];
    NSString *buttonTitle = @"";
    
    switch (gp.directionType) {
        case UNDEFINED:
            gp.directionType = BOTH;
            buttonTitle = @"BOTH";
            break;
        case BOTH:
            gp.directionType = VERTICAL;
            buttonTitle = @"VERTICAL";
            break;
        case VERTICAL:
            gp.directionType = HORIZONTAL;
            buttonTitle = @"HORIZONTAL";
            break;
        case HORIZONTAL:
            gp.directionType = UNDEFINED;
            buttonTitle = @"NONE";
            break;
        default:
            break;
    }
    
    [self.springButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (IBAction)clickOffsetButton:(id)sender {
    GlobalProperty *gp = [GlobalProperty getInstance];
    NSString *buttonTitle = @"";
    
    switch (gp.offsetType) {
        case OFFSET_OFF:
            gp.offsetType = OFFSET_ON;
            buttonTitle = @"ON";
            break;
        case OFFSET_UNDEFINED:
        case OFFSET_ON:
            gp.offsetType = OFFSET_OFF;
            buttonTitle = @"OFF";
        default:
            break;
    }
    
    [self.offsetButton setTitle:buttonTitle forState:UIControlStateNormal];
    
}

- (IBAction)clickedBookmarkButton:(id)sender {
    [self showBookmarkSettingView:[[Bookmark alloc] initWithTitle:@"new"]];
}

#pragma mark -
#pragma mark UIStickyViewDelegate
-(void)beginSetting:(UIStickyView *)sticky {
    self.edittedSticky = sticky;
    [self showBookmarkSettingView:sticky.bookmark];
}

#pragma mark -
#pragma mark BookmarkSettingViewControllerDelegate

-(void)showMapView:(Bookmark *)bookmark {
    msViewCtr = [[MapSearchViewController alloc] initWithNibName:@"MapSearchViewController" bundle:nil];
    [msViewCtr initializeWithBookmark:bookmark];
    msViewCtr.delegate = self;
    
    CGRect window = [[UIScreen mainScreen] bounds];
    msViewCtr.view.center = CGPointMake(window.size.height/2, window.size.width/2);
    [msViewCtr.view setAlpha:0.1];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [msViewCtr.view setAlpha:1.0];
    
    [UIView commitAnimations];
    
    [self.view addSubview:msViewCtr.view];
    [msViewCtr showMapView];
}

-(void)savedBookmark:(Bookmark *)bookmark {
    
    if(self.edittedSticky != nil) {
        if ([BookmarkDAO update:bookmark]) {
            [self.edittedSticky initializeWithBookmark:bookmark];
        }

        self.edittedSticky = nil;
    } else {
        [self registerStickyWithBookmark:bookmark];
    }
}

#pragma mark -
#pragma mark MapSearchViewControllerDelegate
-(void)selectedLocationOnMap:(Bookmark *)bm {
    [bsViewCtr refleshWithBookmark:bm];
    
    [msViewCtr.view removeFromSuperview];
    
}

-(void)canceledMapView {
    [msViewCtr.view removeFromSuperview];
}

-(BOOL)shouldAutorotate {
    return YES;
}


// Deprecated...
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ((interfaceOrientation == UIDeviceOrientationLandscapeLeft) ||
        (interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
        return YES;
    } else {
        return NO;
    }
    
    //	return YES; // 全方向に設定する場合は、単にYESを返す
}


@end
