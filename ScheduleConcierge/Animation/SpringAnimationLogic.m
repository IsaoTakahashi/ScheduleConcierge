//
//  SpringAnimationLogic.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/19.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "SpringAnimationLogic.h"

@implementation SpringAnimationLogic

#pragma mark -
#pragma Initializer
- (id) initWithTarget:(UIView*)target effectedViewArray:(NSArray*)effectedArray {
    if (self = [super init]) {
        self.targetView = target;
        self.effectedViewArray = effectedArray;
    }
    
    return self;
}

#pragma mark -
#pragma mark Animation Trigger
- (Boolean) prepareAnimation {
    return false;
}

- (Boolean) executeAnimation {
    return false;
}

- (Boolean) stopAnimation {
    return false;
}

@end
