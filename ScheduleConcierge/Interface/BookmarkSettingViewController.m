//
//  BookmarkSettingViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "BookmarkSettingViewController.h"
#import "NSString+Validate.h"
#import "NSDate+Softbuild.h"

@interface BookmarkSettingViewController ()

@end

#define CAL_START   1
#define CAL_END     2

@implementation BookmarkSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        [self viewSetting];
        [self buttonSetting];
        
        self.bookmark = [[Bookmark alloc] initWithTitle:@""];
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

-(void)buttonSetting {
    
    self.wButton = [BButton awesomeButtonWithOnlyIcon:FAIconBookmark color:[UIColor blueColor]];
    self.wButton.frame = self.webButton.frame;
    [self.wButton addTarget:self action:@selector(clickedWebButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.wButton];
    
    [self.mapButton setType:BButtonTypeSuccess];
    [self.startDateButton setType:BButtonTypeDefault];
    [self.endDateButton setType:BButtonTypeDefault];
    
    [self.saveButton setType:BButtonTypeInfo];
    [self.cancelButton setType:BButtonTypeGray];
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
}

-(void)removeViewAnimation {
    [self.view setAlpha:1.0];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAnimationEnd)];
    
    [self.view setAlpha:0.0];
    
    [UIView commitAnimations];
}

-(void)removeAnimationEnd {
    [self.view removeFromSuperview];
}

-(void)refleshWithBookmark:(Bookmark*)bm {
    //create copy
    self.bookmark = [Bookmark bookmarkWithBookmark:bm];
    
    self.titleField.text = self.bookmark.t_title;
    self.placeField.text = self.bookmark.t_place;
    
    if (self.bookmark.r_latitude != 0.0f || self.bookmark.r_longitude != 0.0f) {
        self.locationFixedLabel.text = @"Fixed!";
        self.locationFixedLabel.textColor = [UIColor blackColor];
    } else {
        self.locationFixedLabel.text = @"UnFixed";
        self.locationFixedLabel.textColor = [UIColor darkGrayColor];
    }
    
    if (self.bookmark.d_start_date != nil) {
        self.startDateLabel.text = [NSString stringWithDate:self.bookmark.d_start_date format:@"YYYY/MM/dd"];
    }
    if (self.bookmark.d_end_date != nil) {
        self.endDateLabel.text = [NSString stringWithDate:self.bookmark.d_end_date format:@"YYYY/MM/dd"];
    }
    
    if (![self.bookmark.t_url isEmpty]) {
        [self.wButton setColor:[UIColor blueColor]];
    } else {
        [self.wButton setColor:[UIColor grayColor]];
    }
    
}

-(void)saveBookmark {
    self.bookmark.t_title = self.titleField.text;
    self.bookmark.t_place = self.placeField.text;
}

-(void)hideKeyboard {
    [self.titleField resignFirstResponder];
    [self.placeField resignFirstResponder];
}

-(void)showCalendar:(NSInteger)tag {
    self.calendarView = [CKCalendarView new];
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    self.calendarView.tag = tag;
    self.calendarView.center = self.view.frame.origin;
    
    switch (tag) {
        case CAL_START:
            if (self.bookmark.d_start_date != nil) {
                self.calendarView.date = self.bookmark.d_start_date;
            }
            break;
        case CAL_END:
            if (self.bookmark.d_end_date != nil) {
                self.calendarView.date = self.bookmark.d_end_date;
            }
            break;
        default:
            break;
    }
    
    
    [self.view.superview addSubview:self.calendarView];
}

#pragma mark -
#pragma mark CKCalendarView Delegate
-(void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date {
    NSDate *newMonth = [date truncWithScale:NSMonthCalendarUnit];
    NSDate *prevMonth = [[CalendarView previousDate] truncWithScale:NSMonthCalendarUnit];
    
    if ([newMonth timeToDate:prevMonth scale:NSMonthCalendarUnit] != 0) {
        return;
    }
    
    UIAlertView *alert;
    switch (CalendarView.tag) {
        case CAL_START:
            
            if (self.bookmark.d_end_date != nil && [date compare:self.bookmark.d_end_date] == NSOrderedDescending) {
                alert = [[UIAlertView alloc] initWithTitle:@"StartDate" message:@"Please Choose date which is earlier than EndDate" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            } else {
                self.bookmark.d_start_date = date;
            }
            break;
        case CAL_END:
            
            if (self.bookmark.d_start_date != nil && [date compare:self.bookmark.d_start_date] == NSOrderedAscending) {
                alert = [[UIAlertView alloc] initWithTitle:@"EndDate" message:@"Please Choose date which is later than StartDate" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            } else {
                self.bookmark.d_end_date = date;
            }
            break;
        default:
            break;
    }
    
    [self.calendarView removeFromSuperview];
    
    [self refleshWithBookmark:self.bookmark];
}

#pragma mark -
#pragma mark CLCalendarView DataSource
-(NSArray*)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date {
    //TODO: I'd like to add logic for listing bookmark on the calendar table
    return [NSArray new];
}

#pragma mark -
#pragma mark WebSearchViewController Delegate
-(void)selectedBookmarkURL:(Bookmark *)bm {
    [self.wsViewCtr.view removeFromSuperview];
    
    [self refleshWithBookmark:bm];
}

- (IBAction)clickedSaveButton:(id)sender {
    
    if([self.titleField.text isEmpty]) {
        return;
    }
    
    
    [self saveBookmark];
    [self.delegate savedBookmark:self.bookmark];
    
    [self removeViewAnimation];
}

- (IBAction)clickedCancelButton:(id)sender {
    [self hideKeyboard];
    [self removeViewAnimation];
}


- (IBAction)clickedStartDateButton:(id)sender {
    [self hideKeyboard];
    [self showCalendar:CAL_START];
}

- (IBAction)clickedEndDateButton:(id)sender {
    [self hideKeyboard];
    [self showCalendar:CAL_END];
}

- (IBAction)clickedMapButton:(id)sender {
    [self saveBookmark];
    [self hideKeyboard];
    
    [self.delegate showMapView:self.bookmark];
}

- (IBAction)clickedWebButton:(id)sender {
    [self saveBookmark];
    [self hideKeyboard];
    
    self.wsViewCtr = [[WebSearchViewController alloc] initWithNibName:@"WebSearchViewController" bundle:nil];
    [self.wsViewCtr initializeWithBookmark:self.bookmark];
    self.wsViewCtr.delegate = self;
    
    CGRect window = [[UIScreen mainScreen] bounds];
    self.wsViewCtr.view.center = CGPointMake(window.size.height/2, window.size.width/2);
    [self.wsViewCtr.view setAlpha:0.1];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self.wsViewCtr.view setAlpha:1.0];
    
    [UIView commitAnimations];
    
    [self.view.superview addSubview:self.wsViewCtr.view];
}

@end
