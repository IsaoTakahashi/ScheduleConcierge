//
//  DirectionViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/26.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "DirectionViewController.h"

@interface DirectionViewController ()

@end

@implementation DirectionViewController

@synthesize direction = _direction;

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
    
    // corner setting
    layer.cornerRadius = 3;
    layer.borderWidth = 1;
    layer.borderColor = [[UIColor blackColor] CGColor];
}

-(void)setDirection:(Direction *)dir {
    [self setDirectionSetting:dir];
}

-(void)setDirectionSetting:(Direction*)dir {
    _direction = dir;
    NSString *timeString = nil;
    int requiredMinutes = (int)[self.direction.departureTime timeToDate:self.direction.destinationTime scale:NSMinuteCalendarUnit];
    if (requiredMinutes < 60) {
        timeString = [NSString stringWithFormat:@"%d min.",requiredMinutes];
    } else if (requiredMinutes < 60 * 24) {
        timeString = [NSString stringWithFormat:@"%.1f hour",(double)requiredMinutes / 60.0f];
    } else {
        timeString = [NSString stringWithFormat:@"%.1f day",(double)requiredMinutes / (60.0f * 24.0f)];
    }
    
    
    self.requiredTimeLabel.attributedText = [[NSAttributedString alloc] initWithString:timeString];
    self.requiredTimeLabel.textAlignment = NSTextAlignmentCenter;
}

@end
