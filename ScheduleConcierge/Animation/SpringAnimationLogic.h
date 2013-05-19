//
//  SpringAnimationLogic.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/19.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum effectDirectionType : NSUInteger {
    UNDEFINED,
    BOTH,
    VERTICAL,
    HORIZONTAL
} effectDirectionType;

typedef enum positoinOffsetType : NSUInteger {
    OFFSET_UNDEFINED,
    OFFSET_OFF,
    OFFSET_ON
} positionOffsetType;

@interface SpringAnimationLogic : NSObject {
    
}

@property (strong,nonatomic) UIView *targetView;
@property (strong,nonatomic) NSMutableArray *effectedViewArray;
@property (strong,nonatomic) NSMutableArray *baseCenterArray;
@property (strong,nonatomic) NSMutableArray *moveDistanceArray;
@property (nonatomic) effectDirectionType directionType; //バネの動く方向の設定
@property (nonatomic) positionOffsetType offsetType; //影響させるViewが、影響させるViewを「乗り越える」かどうかの設定
@property (nonatomic) CGFloat springConstant; //影響するViewのバネ定数
@property (nonatomic) CGFloat repulsionConst; //影響させるViewの基本反発力

- (id) initWithTarget:(UIView*)target effectedViewArray:(NSMutableArray*)effectedArray;
- (Boolean) prepareAnimation;
- (Boolean) executeAnimation;
- (Boolean) stopAnimation;

@end
