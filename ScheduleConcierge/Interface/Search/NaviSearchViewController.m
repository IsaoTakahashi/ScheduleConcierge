//
//  NaviSearchViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/23.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "NaviSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+Softbuild.h"

@interface NaviSearchViewController ()

@end

@implementation NaviSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pickerStringArray = [@[@"500m",@"1km",@"3km",@"5km",@"10km",@"no limit"] mutableCopy];
        [self viewSetting];
    }
    return self;
}

-(void) inisializeWithBookmark:(Bookmark *)bm {
    self.condition = [SearchCondition new];
    self.condition.bookmark = [Bookmark bookmarkWithBookmark:bm];
    self.condition.bookmark.t_place = @"Target";
    self.condition.searchAreaRadius = 1;
    
    if (self.condition.bookmark.r_latitude == 0 && self.condition.bookmark.r_longitude == 0) {
        //FIXME:仮座標をセット
        self.condition.bookmark.r_latitude = 35.610557;
        self.condition.bookmark.r_longitude = 139.749649;
    } else {
        [self refreshWithBookmark:bm];
    }
}

-(void)viewSetting {
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
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    self.timeBackLabel.layer.cornerRadius = 5;
    self.areaBackLabel.layer.cornerRadius = 5;
    
    [self.mapButton setType:BButtonTypeSuccess];
    [self.seachButton setType:BButtonTypePrimary];
}

-(void)refreshWithBookmark:(Bookmark*)bm {
    self.condition.bookmark = bm;
    
    if (self.condition.bookmark.r_latitude == 0 && self.condition.bookmark.r_longitude == 0) {
        self.mapLabel.text = @"UnFixed";
        self.mapLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.mapLabel.text = @"Fixed!";
        self.mapLabel.textColor = [UIColor blackColor];
    }
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
#pragma mark MapSearchViewController Delegate
-(void)selectedLocationOnMap:(Bookmark *)bm {
    
    [self.msViewCtr.view removeFromSuperview];
    [self refreshWithBookmark:bm];
}

-(void)canceledMapView {
    [self.msViewCtr.view removeFromSuperview];
}

#pragma mark -
#pragma mark UIPickerView Delegate/Data Source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerStringArray.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerStringArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    NSInteger radius = 0;
    switch (row) {
        case M_500:
            radius = 500;
            break;
        case KM_1:
            radius = 1000;
            break;
        case KM_3:
            radius = 3000;
            break;
        case KM_5:
            radius = 5000;
            break;
        case KM_10:
            radius = 10000;
            break;
        default:
            break;
    }
    
    self.condition.searchAreaRadius = radius;
}


- (IBAction)clickedMapButton:(id)sender {
    self.msViewCtr = [[MapSearchViewController alloc] initWithNibName:@"MapSearchViewController" bundle:nil];
    [self.msViewCtr initializeWithBookmark:self.condition.bookmark];
    self.msViewCtr.delegate = self;
    
    [self.msViewCtr.view setAlpha:0.1];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self.msViewCtr.view setAlpha:1.0];
    
    [UIView commitAnimations];
    
    [self.view addSubview:self.msViewCtr.view];
    [self.msViewCtr showMapView];
}

- (IBAction)clickedSearchButton:(id)sender {
    //TODO: set search condition from each component
    Bookmark *bm = self.condition.bookmark;

    NSDate *startDate = self.startTimePicker.date;
    NSDate *endDate = self.endTimePicker.date;
    
    bm.d_start_date = [startDate truncWithScale:NSDayCalendarUnit];
    bm.d_end_date = [endDate truncWithScale:NSDayCalendarUnit];
    bm.r_start_time = [startDate getHour];
    bm.r_end_time = [endDate getHour];
    
    [self.delegate search:self.condition];
}

- (IBAction)clickedCancelButton:(id)sender {
    
    [self.delegate search:nil];
}
@end
