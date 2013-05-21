//
//  GlobalProperty.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpringAnimationLogic.h"

@interface GlobalProperty : NSObject

@property(nonatomic)effectDirectionType directionType;
@property(nonatomic)positionOffsetType offsetType;

+ (GlobalProperty *)getInstance;
@end
