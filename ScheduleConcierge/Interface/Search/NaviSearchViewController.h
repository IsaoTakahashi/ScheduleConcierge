//
//  NaviSearchViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/23.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
#import "SearchCondition.h"
#import "MapSearchViewController.h"

typedef enum SearchAreaRadiusType : NSUInteger {
    M_500,
    KM_1,
    KM_3,
    KM_5,
    KM_10,
    NO_LIMIT
} SearchAreaRadiusType;

@protocol NaviSearchViewControllerDelegate <NSObject>

-(void)search:(SearchCondition*)condition;

@end

@interface NaviSearchViewController : UIViewController<MapSearchViewControllerDelegate,UIPickerViewAccessibilityDelegate,UIPickerViewDataSource>

@property (nonatomic) id<NaviSearchViewControllerDelegate> delegate;
@property (nonatomic) SearchCondition *condition;
@property (nonatomic) MapSearchViewController *msViewCtr;
@property (nonatomic) NSMutableArray* pickerStringArray;

-(void)inisializeWithBookmark:(Bookmark*)bm;

@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;
@property (weak, nonatomic) IBOutlet BButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *areaPicker;
@property (weak, nonatomic) IBOutlet BButton *seachButton;

@property (weak, nonatomic) IBOutlet UILabel *timeBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaBackLabel;

- (IBAction)clickedMapButton:(id)sender;
- (IBAction)clickedSearchButton:(id)sender;
- (IBAction)clickedCancelButton:(id)sender;

@end
