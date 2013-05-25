//
//  SpringAnimationLogic.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/19.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "SpringAnimationLogic.h"

@implementation SpringAnimationLogic

static CGFloat const BASE_MOVE_DISTANCE = 5.0f;

#pragma mark -
#pragma Initializer
- (id) initWithTarget:(UIView*)target effectedViewArray:(NSMutableArray*)effectedArray {
    if (self = [super init]) {
        self.targetView = target;
        self.effectedViewArray = effectedArray;
        self.directionType = UNDEFINED;
        self.offsetType = OFFSET_UNDEFINED;
        self.springConstant = 0;
        self.repulsionConst = 0;
    }
    
    return self;
}

#pragma mark -
#pragma mark Animation Trigger

-(Boolean)validateSetting {
    return (self.directionType == UNDEFINED ||
            self.offsetType == OFFSET_UNDEFINED ||
            self.springConstant <= 0 ||
            self.repulsionConst <- 0);
}

-(Boolean)prepareAnimation {
    // target Object validation
    if(self.targetView == nil || self.effectedViewArray == nil) {
        return false;
    }
    
    // set status validation
    if ([self validateSetting]) {
        return false;
    }
    
    // set base points for each view
    [self setBaseCenterPoints];
    
    [self logTargetObjects];
    [self logAnimationStatus];
    
    return true;
}

- (Boolean) executeAnimation {
    
    if ([self validateSetting]) {
        return false;
    }
    
    [self calcMoveDistance];
    
    if (self.moveDistanceArray.count != self.effectedViewArray.count) {
        return false;
    }
    
    [self animateAllTarget];
    
    return true;
}

- (Boolean) stopAnimation {
    return false;
}

#pragma mark -
#pragma mark Calculation Logic

// 各Viewの、アニメーション前の中心位置を記憶
-(void)setBaseCenterPoints {
    self.baseCenterArray = [NSMutableArray new];
    
    for (UIView *view in self.effectedViewArray) {
        CGPoint point = view.center;
        [self.baseCenterArray addObject:[NSValue valueWithCGPoint:point]];
    }
}

// 各Viewの移動量を計算して、移動距離配列に格納
-(void)calcMoveDistance {
    int viewCount = 0;
    self.moveDistanceArray = [NSMutableArray new];
    
    for (UIView *view in self.effectedViewArray) {
        
        CGPoint moveDistancePoint = CGPointZero;
        CGPoint basePoint = [(NSValue*)self.baseCenterArray[viewCount] CGPointValue];
        
        // if view and targetView is same, dont't calculate
        if (view.tag == self.targetView.tag) {
            [self.moveDistanceArray addObject:[NSValue valueWithCGPoint:CGPointZero]];
            viewCount++;
            continue;
        }
        
        CGPoint distanceVectorFromBasePoint = [self calcDistanceVectorWithCGPoint1:view.center CGPoint2:basePoint];

        
        // hit test
        if ([self hitTestView1:view View2:self.targetView]) {
            CGPoint distanceVectorFromTarget = [self calcDistanceVectorWithCGPoint1:view.center
                                                                           CGPoint2:[self.targetView.superview convertPoint:self.targetView.center toView:view.superview]];
            
            CGFloat distanceScalarFromTarget = [self calcDistanceScalarWithCGPoint1:view.center
                                                                           CGPoint2:[self.targetView.superview convertPoint:self.targetView.center toView:view.superview]];
            CGPoint normalizedVector = CGPointMake(distanceVectorFromTarget.x / distanceScalarFromTarget, distanceVectorFromTarget.y / distanceScalarFromTarget);
            
            //復元力計算
            CGFloat restorativeForce = [self calcRestorativeForceWithCurrentPosition:view.center basePoint:basePoint];
            
            //反発力計算
            CGFloat reputativeForce = [self calcReputativeForce:view];
            
            // 反発力を正として、最終的に適用される力を計算
            CGFloat appliedForce = reputativeForce - restorativeForce;
            
            moveDistancePoint = CGPointMake(appliedForce * normalizedVector.x, appliedForce * normalizedVector.y);
            
            // 「TargetViewが、各Viewを乗り越える」判定
            if (self.offsetType == OFFSET_ON) {
                CGFloat distanceScalarFromTarget = [self calcDistanceScalarWithCGPoint1:view.center
                                                                               CGPoint2:[self.targetView.superview convertPoint:self.targetView.center toView:view.superview]];
                CGFloat distanceScalarFromBasePoint = [self calcDistanceScalarWithCGPoint1:view.center CGPoint2:basePoint];
                
                if (distanceScalarFromTarget < distanceScalarFromBasePoint) {
                    moveDistancePoint = CGPointMake(-distanceVectorFromBasePoint.x, -distanceVectorFromBasePoint.y);
                }
            }
            
            
            
            //NSLog(@"Applied Force: %f",appliedForce);
        } else {
            if (!CGPointEqualToPoint(view.center, basePoint)) {
                CGRect baseRect = CGRectMake(view.frame.origin.x - distanceVectorFromBasePoint.x, view.frame.origin.y - distanceVectorFromBasePoint.y,
                                             view.frame.size.width, view.frame.size.height);
                
                // 元の位置に戻っても、targetViewと重ならない場合、元の位置まで戻す
                if (!CGRectIntersectsRect(baseRect, self.targetView.frame)) {
                    moveDistancePoint = CGPointMake(-distanceVectorFromBasePoint.x, -distanceVectorFromBasePoint.y);
                    NSLog(@"Back to base Position");
                } else {
                    // 復元力計算
                    CGFloat restorativeForce = [self calcRestorativeForceWithCurrentPosition:view.center basePoint:basePoint];
                    moveDistancePoint = CGPointMake(-distanceVectorFromBasePoint.x * restorativeForce, -distanceVectorFromBasePoint.y * restorativeForce);
                    
                    //NSLog(@"RestorativeForce: %f",restorativeForce);
                }
                
            }
        }
        
        [self.moveDistanceArray addObject:[NSValue valueWithCGPoint:moveDistancePoint]];
        viewCount++;
        
        //NSLog(@"move DistancePoint: %@", NSStringFromCGPoint(moveDistancePoint));
    }
}

// 2つのViewの当たり判定
-(Boolean)hitTestView1:(UIView*)view1 View2:(UIView*)view2 {
    return CGRectIntersectsRect(view1.frame, view2.frame);
}

//ViewとViewの反発力＝「targetViewが、他のViewを押し出す力」を計算
-(CGFloat)calcReputativeForce:(UIView*)view {
    CGFloat reputativeForce = 0.0f;
    
    CGFloat distanceScalar = [self calcDistanceScalarWithCGPoint1:view.center
                                                         CGPoint2:[self.targetView.superview convertPoint:self.targetView.center toView:view.superview]];
    
    reputativeForce = self.springConstant / distanceScalar;
    
    return reputativeForce;
}

//Viewの復元力＝「元の位置に戻ろうとする力」を計算
-(CGFloat)calcRestorativeForceWithCurrentPosition:(CGPoint)currentPoint basePoint:(CGPoint)basePoint {
    CGFloat restorativeForce = 0.0f;
    
    CGFloat distanceScalar = [self calcDistanceScalarWithCGPoint1:currentPoint CGPoint2:basePoint];
    
    restorativeForce = self.repulsionConst * distanceScalar;
    
    return restorativeForce;
}

// 2点間の距離をスカラーで返す
-(CGFloat)calcDistanceScalarWithCGPoint1:(CGPoint)point1 CGPoint2:(CGPoint)point2 {
    return sqrtf( pow(point1.x-point2.x,2.0) + pow(point1.y - point2.y,2.0));
}

// 2点間の距離をベクトルで返す
-(CGPoint)calcDistanceVectorWithCGPoint1:(CGPoint)point1 CGPoint2:(CGPoint)point2 {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

#pragma mark -
#pragma mark Animation Logic
-(void)animateAllTarget {
    int viewCount = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    
    for (UIView *view in self.effectedViewArray) {
        CGPoint moveDistancePoint = [(NSValue*)self.moveDistanceArray[viewCount] CGPointValue];
        
        if (isnan(moveDistancePoint.x) || isnan(moveDistancePoint.y) ||
            isinf(moveDistancePoint.x) || isinf(moveDistancePoint.y)) {
            viewCount++;
            continue;
        }
        
        switch (self.directionType) {
            case BOTH:
                break;
            case VERTICAL:
                moveDistancePoint.x = 0.0f;
                break;
            case HORIZONTAL:
                moveDistancePoint.y = 0.0f;
                break;
            default:
                break;
        }
        
        CGPoint distinationPoint = CGPointMake(view.center.x + moveDistancePoint.x, view.center.y + moveDistancePoint.y);
        view.center = distinationPoint;
        
        viewCount++;
    }
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Logger
-(void)logTargetObjects {
    NSLog(@"target View = %@",[self.targetView description]);
    NSLog(@"effected View Array = %@",[self.effectedViewArray description]);
}

-(void)logAnimationStatus {
    NSLog(@"Effecct Direction Type = %d",self.directionType);
    NSLog(@"Position Offset Type = %d",self.offsetType);
}

@end
