//
//  TimePickerViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/23.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bookmark.h"
#import "BButton.h"

@protocol TimePickerViewControllerDelegate <NSObject>

-(void)selectedTime:(Bookmark*)bm;

@end

@interface TimePickerViewController : UIViewController

@property (nonatomic) id<TimePickerViewControllerDelegate> delegate;
@property (nonatomic) Bookmark *bookmark;

-(void)initializeWithBookmark:(Bookmark*)bm;

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) IBOutlet BButton *okButton;
@property (weak, nonatomic) IBOutlet BButton *cancelButton;

- (IBAction)clickedOKButton:(id)sender;
- (IBAction)clickedCancelButton:(id)sender;

@end
