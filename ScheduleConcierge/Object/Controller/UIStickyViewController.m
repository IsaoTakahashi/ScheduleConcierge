//
//  UIStickyViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "UIStickyViewController.h"

@interface UIStickyViewController ()

@end

@implementation UIStickyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIStickyView *baseView = (UIStickyView*)self.view;
        baseView.stickyViewDelegate = self;
        NSLog(@"%@",baseView.description);
        [baseView initialize];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIStickyViewDelegate
- (NSMutableArray*)getStickyArray {
    return [self.delegate getStickyArrayForTargetStickyView];
}

@end
