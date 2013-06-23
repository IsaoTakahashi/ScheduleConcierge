//
//  BookmarkSettingViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>
#import "BButton.h"
#import "Bookmark.h"
#import "WebSearchViewController.h"
#import "CalendarKit.h"

@protocol BookmarkSettingViewControllerDelegate <NSObject>

-(void)showMapView:(Bookmark*)bookmark;
-(void)savedBookmark:(Bookmark*)bookmark;

@end

@interface BookmarkSettingViewController : UIViewController<GMSMapViewDelegate,WebSearchViewControllerDelegate,CKCalendarViewDelegate,CKCalendarViewDataSource>

@property (nonatomic) Bookmark *bookmark;
@property (nonatomic) id<BookmarkSettingViewControllerDelegate> delegate;
@property (nonatomic) GMSMapView *gmsMapView;
@property (nonatomic) WebSearchViewController *wsViewCtr;
@property (nonatomic) CKCalendarView *calendarView;
@property (nonatomic) BButton *wButton;

//Outlet
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *placeField;
@property (weak, nonatomic) IBOutlet BButton *mapButton;
@property (weak, nonatomic) IBOutlet BButton *startDateButton;
@property (weak, nonatomic) IBOutlet BButton *endDateButton;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationFixedLabel;

@property (weak, nonatomic) IBOutlet BButton *saveButton;
@property (weak, nonatomic) IBOutlet BButton *cancelButton;
@property (weak, nonatomic) IBOutlet BButton *webButton;


//Event
-(void)refleshWithBookmark:(Bookmark*)bm;

//Event -button
- (IBAction)clickedSaveButton:(id)sender;
- (IBAction)clickedCancelButton:(id)sender;


- (IBAction)clickedStartDateButton:(id)sender;
- (IBAction)clickedEndDateButton:(id)sender;

- (IBAction)clickedMapButton:(id)sender;
- (IBAction)clickedWebButton:(id)sender;

//Event -text field

@end
