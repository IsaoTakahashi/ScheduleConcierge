//
//  Direction.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Softbuild.h"

typedef enum TransportationType : NSUInteger {
    UNKNOWN_WAY,
    WALK,
    CAR,
    TRAIN,
    AIRPLANE
} TransportationType;

@interface Direction : NSObject

@property(nonatomic) NSString *departurePlace;
@property(nonatomic) NSString *destinationPlace;
@property(nonatomic) NSDate   *departureTime;
@property(nonatomic) NSDate   *destinationTime;
@property(nonatomic) TransportationType transportationType;
@property(nonatomic) NSInteger *cost;
@property(nonatomic) NSNumber *distance;

@end
