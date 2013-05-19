//
//  SpringAnimationLogic.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/19.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum effectDirectionType : NSUInteger {
    BOTH,
    VERTICAL,
    HORIZONTAL
} effectDirectionType;

typedef enum positoinOffsetType : Boolean {
    YES,
    NO
} positionOffsetType;

@interface SpringAnimationLogic : NSObject {
    
}

@property (strong,nonatomic) UIView *targetView;
@property (strong,nonatomic) NSArray *effectedViewArray;
@property (nonatomic) effectDirectionType directionType;
@property (nonatomic) positionOffsetType offsetType;

- (id) initWithTarget:(UIView*)target effectedViewArray:(NSArray*)effectedArray;
- (Boolean) prepareAnimation;
- (Boolean) executeAnimation;
- (Boolean) stopAnimation;

@end
