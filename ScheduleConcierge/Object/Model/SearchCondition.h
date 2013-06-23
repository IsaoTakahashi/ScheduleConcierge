//
//  SearchCondition.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/23.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bookmark.h"

@interface SearchCondition : NSObject

@property (nonatomic) Bookmark *bookmark;
@property (nonatomic) NSInteger searchAreaRadius;

@end
