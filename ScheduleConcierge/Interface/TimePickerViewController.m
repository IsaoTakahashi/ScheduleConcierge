//
//  TimePickerViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/23.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "TimePickerViewController.h"
#import "NSDate+Softbuild.h"

@interface TimePickerViewController ()

@end

@implementation TimePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initializeWithBookmark:(Bookmark*)bm {
    self.bookmark = bm;
    NSDate *date;
    
    switch (self.view.tag) {
        case 1:
            date = [self.bookmark.d_start_date truncWithScale:NSDayCalendarUnit];
            date =[date addHour:(int)self.bookmark.r_start_time];
            break;
        case 2:
            date = [self.bookmark.d_end_date truncWithScale:NSDayCalendarUnit];
            date = [date addHour:(int)self.bookmark.r_end_time];
            break;
        default:
            break;
    }
    
    
    self.picker.date = date;
}

-(void)buttonSetting {
    [self.okButton setType:BButtonTypeInfo];
    [self.okButton setType:BButtonTypeGray];
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

- (IBAction)clickedOKButton:(id)sender {
    NSInteger hour = [self.picker.date getHour];
    
    switch (self.view.tag) {
        case 1:
            self.bookmark.r_start_time = hour;
            break;
        case 2:
            self.bookmark.r_end_time = hour;
            break;
        default:
            break;
    }
    
    [self.delegate selectedTime:self.bookmark];
}

- (IBAction)clickedCancelButton:(id)sender {
    [self.delegate selectedTime:nil];
}
@end
