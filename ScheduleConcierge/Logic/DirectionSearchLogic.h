//
//  DirectionSearchLogic.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Direction.h"
#import "NSString+URLEncoding.h"

@interface DirectionSearchLogic : NSObject

@property (strong,nonatomic) NSMutableArray *directionArray;

-(Boolean)searchDirections;

@end
