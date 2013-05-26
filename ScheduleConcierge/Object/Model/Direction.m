//
//  Direction.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "Direction.h"

@implementation Direction

-(id)init {
    if(self = [super init]) {
        self.departurePlace = @"";
        self.destinationPlace = @"";
        self.departureTime = [[NSDate date] truncWithScale:NSDayCalendarUnit];
        self.destinationTime = [[NSDate date] truncWithScale:NSDayCalendarUnit];
        self.transportationType = UNKNOWN_WAY;
        self.cost = 0;
        self.distance = 0;
    }
    
    return self;
}

@end
