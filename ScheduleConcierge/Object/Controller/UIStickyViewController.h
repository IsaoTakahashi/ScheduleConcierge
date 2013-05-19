//
//  UIStickyViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIStickyView.h"

@protocol UIStickyViewControllerDelegate <NSObject>

-(NSMutableArray*) getStickyArrayForTargetStickyView;

@end

@interface UIStickyViewController : UIViewController<UIStickyViewDelegate>

@property (strong,nonatomic) id<UIStickyViewControllerDelegate> delegate;

@end
