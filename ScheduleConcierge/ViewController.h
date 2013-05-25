//
//  ViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/29.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickyManager.h"

@interface ViewController : UIViewController {

}

@property (weak, nonatomic) IBOutlet UIButton *springButton;
@property (weak, nonatomic) IBOutlet UIButton *offsetButton;
- (IBAction)handlePanGesture:(UIPanGestureRecognizer*)sender;
- (IBAction)clickStickyButton:(id)sender;
- (IBAction)clidkSpringButton:(UIButton*)sender;
- (IBAction)clickOffsetButton:(id)sender;

@end
