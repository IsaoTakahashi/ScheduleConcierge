//
//  DateBarViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DateBarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *DateLabel;

- (void) setDate:(NSDate*)date;
@end
