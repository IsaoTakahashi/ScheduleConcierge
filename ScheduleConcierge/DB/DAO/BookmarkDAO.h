//
//  BookmarkDAO.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bookmark.h"
#import "SimpleDBManager.h"

@interface BookmarkDAO : NSObject
+(bool)inert:(Bookmark*)bookmark;
+(NSMutableArray*)selectAll;
+(bool)deleteWithId:(Bookmark*)bookmark;
@end
