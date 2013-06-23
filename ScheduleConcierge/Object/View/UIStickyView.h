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
#import "Bookmark.h"

typedef enum AlertTabType : NSUInteger {
    CREATE,
    REMOVE
} AlertTabType;

@protocol UIStickyViewDelegate;

@interface UIStickyView : UIView<UIGestureRecognizerDelegate,UIAlertViewDelegate,SimpeNetworkDelegate>
{
    CGPoint lastPoint_;
}
@property (nonatomic) id<UIStickyViewDelegate> delegate;
@property (nonatomic) Bookmark* bookmark;
@property (strong, nonatomic) SpringAnimationLogic *springAnimationLogic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@property (weak, nonatomic) IBOutlet UILabel *stayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
- (void)initialize;
- (void)initializeWithBookmark:(Bookmark*)bm;
- (void)setViewPosition:(CGPoint)diffVector;

@end

@protocol UIStickyViewDelegate <NSObject>

-(void)beginSetting:(UIStickyView*)sticky;

@end
