//
//  BookmarkSettingViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "BookmarkSettingViewController.h"

@interface BookmarkSettingViewController ()

@end

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
    self.bookmark = bm;
    
    self.titleField.text = self.bookmark.t_title;
    self.placeField.text = self.bookmark.t_place;
    
    if(self.bookmark.r_latitude != 0.0f || self.bookmark.r_longitude != 0.0f) {
        self.locationFixedLabel.text = @"Fixed!";
        self.locationFixedLabel.textColor = [UIColor greenColor];
    } else {
        self.locationFixedLabel.text = @"UnFixed";
        self.locationFixedLabel.textColor = [UIColor darkGrayColor];
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
}

- (IBAction)clickedEndDateButton:(id)sender {
    [self hideKeyboard];
}

- (IBAction)clickedMapButton:(id)sender {
    [self saveBookmark];
    [self hideKeyboard];
    
    [self.delegate showMapView:self.bookmark];
}

@end
