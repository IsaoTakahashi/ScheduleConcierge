//
//  TripSuggestionLogic.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/24.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "TripSuggestionLogic.h"
#import "BookmarkDAO.h"

@implementation TripSuggestionLogic

+(NSMutableArray*)suggestionWithCondition:(SearchCondition*)cond {
    NSMutableArray* matchedBMArray = [BookmarkDAO selectWithCondition:cond];
    
    return matchedBMArray;
}

@end
