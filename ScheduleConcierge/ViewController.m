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

@synthesize sample_;

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
                NSLog(@"handled %@",NSStringFromCGPoint([sender locationOfTouch:0 inView:self.view]));
            }
            
            break;
        default:
            break;
            
    }
}

- (IBAction)clickStickyButton:(id)sender
{
    UIStickyViewController *newStickyCtr = [[UIStickyViewController alloc] initWithNibName:@"UIStickyViewController" bundle:nil];
    [self.view addSubview:newStickyCtr.view];
    
    //UIStickyView *newSticky = [[UIStickyView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    //[self.view addSubview:newSticky];
}

@end
