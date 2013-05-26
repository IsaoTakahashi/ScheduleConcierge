//
//  DateBarViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BButton.h"
#import "UIStickyView.h"

@interface DateBarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet BButton *CalcButton;

@property (strong, nonatomic) NSMutableArray *stickies;
@property (strong, nonatomic) NSMutableArray *directionCtrArray;

- (void) setDate:(NSDate*)date;
- (void) sortStickies;
-(Boolean)addSticky:(UIStickyView*)sticky;
-(Boolean)removeSticky:(UIStickyView*)sticky;

- (IBAction)clickRouteButton:(BButton *)sender;

@end
