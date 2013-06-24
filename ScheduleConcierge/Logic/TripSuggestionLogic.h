//
//  TripSuggestionLogic.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/24.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchCondition.h"

@interface TripSuggestionLogic : NSObject

+(NSMutableArray*)suggestionWithCondition:(SearchCondition*)cond;

@end
