//
//  DateBarViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "DateBarViewController.h"
#import "NSDate+Softbuild.h"

@interface DateBarViewController ()

@end

@implementation DateBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self viewSetting];
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

- (void)viewSetting {
    CALayer *layer = self.view.layer;
    
    // shadow setting
    layer.shadowRadius = 5;
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOpacity = 0.5;
    layer.shadowOffset = CGSizeMake(1, 3);
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    // corner setting
    layer.cornerRadius = 5;
    layer.borderWidth = 3;
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void) setDate:(NSDate*)date {
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"MM/dd"];
    UIColor *dayColor;
    
    switch ([date weekday]) {
        case 1:
            dayColor = [UIColor redColor];
            break;
        case 7:
            dayColor = [UIColor blueColor];
            break;
        default:
            dayColor = [UIColor blackColor];
            break;
    }
    
    NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:[f stringFromDate:date] attributes:@{NSForegroundColorAttributeName : dayColor}];
    NSAttributedString *dayString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)",[date stringShortweekdayEn]] attributes:@{NSForegroundColorAttributeName : dayColor}];
    
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithAttributedString:dateString];
    [labelString appendAttributedString:dayString];
    
    self.DateLabel.attributedText = labelString;
    
    
}



@end
