//
//  ViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/29.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    if (self.stickyArray == nil || self.stickyArray.count == 0) {
        self.stickyArray = [NSMutableArray new];
    }
    
    UIStickyViewController *newStickyCtr = [[UIStickyViewController alloc] initWithNibName:@"UIStickyViewController" bundle:nil];
    newStickyCtr.delegate = self;
    [self.view addSubview:newStickyCtr.view];
    
    [self.stickyArray addObject:newStickyCtr.view];
    
    //UIStickyView *newSticky = [[UIStickyView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    //[self.view addSubview:newSticky];
}

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

#pragma mark -
#pragma mark UIStickyViewControllerDelegate
- (NSMutableArray*)getStickyArrayForTargetStickyView {
    return self.stickyArray;
}

@end
