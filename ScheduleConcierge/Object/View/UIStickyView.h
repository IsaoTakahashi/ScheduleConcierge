//
//  UIStickyView.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStickyView : UIView<UIGestureRecognizerDelegate>
{
    CGPoint lastPoint_;
}

- (void) setViewPosition:(CGPoint)diffVector;

@end
