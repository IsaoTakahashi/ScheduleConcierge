//
//  UIStickyView.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageSearchLogic.h"

@protocol UIStickyViewDelegate <NSObject>

- (NSMutableArray*) getStickyArray;

@end

@interface UIStickyView : UIView<UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    CGPoint lastPoint_;
}
@property (weak, nonatomic) id<UIStickyViewDelegate> stickyViewDelegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIWebView *siteWebView;

- (void)initialize;
- (void)setViewPosition:(CGPoint)diffVector;

@end
