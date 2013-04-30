//
//  ViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/29.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIStickyViewController.h"
#import "UIStickyView.h"

@interface ViewController : UIViewController {
    
}

@property (strong, nonatomic) IBOutlet UIView *sample_;

- (IBAction)handlePanGesture:(UIPanGestureRecognizer*)sender;
- (IBAction)clickStickyButton:(id)sender;

@end
