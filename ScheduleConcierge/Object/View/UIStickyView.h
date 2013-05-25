//
//  UIStickyView.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SimpleNetwork.h"
#import "ImageSearchLogic.h"
#import "SpringAnimationLogic.h"

typedef enum AlertTabType : NSUInteger {
    CREATE,
    REMOVE
} AlertTabType;

@interface UIStickyView : UIView<UIGestureRecognizerDelegate,UIAlertViewDelegate,SimpeNetworkDelegate>
{
    CGPoint lastPoint_;
}
@property (strong, nonatomic) SpringAnimationLogic *springAnimationLogic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

- (void)initialize;
- (void)setViewPosition:(CGPoint)diffVector;

@end
