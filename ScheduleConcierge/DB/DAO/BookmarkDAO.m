//
//  BookmarkDAO.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "BookmarkDAO.h"
#import "NSDate+Softbuild.h"

@implementation BookmarkDAO

+(bool)insert:(Bookmark*)bookmark {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool insert_flg = false;
    
    bookmark.d_insert = [NSDate date];
    
    if (bookmark.d_end_date != nil) {
        insert_flg = [db.connection executeUpdate:@"INSERT INTO BOOKMARK \
                (t_title,t_place,r_latitude,r_longitude,d_start_date,d_end_date,r_start_time,r_end_time,i_base_service,t_url,d_insert,i_del_flg) \
                VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
                bookmark.t_title,bookmark.t_place,
                [NSNumber numberWithDouble:bookmark.r_latitude],
                [NSNumber numberWithDouble:bookmark.r_longitude],
                [NSNumber numberWithLong:[[bookmark.d_start_date truncWithScale:NSDayCalendarUnit] timeIntervalSince1970]],
                [NSNumber numberWithLong:[[bookmark.d_end_date truncWithScale:NSDayCalendarUnit] timeIntervalSince1970]],
                [NSNumber numberWithDouble:bookmark.r_start_time],
                [NSNumber numberWithDouble:bookmark.r_end_time],
                [NSNumber numberWithInt:bookmark.i_base_service],
                bookmark.t_url,
                [NSNumber numberWithLong:[bookmark.d_insert timeIntervalSince1970]],
                [NSNumber numberWithInt:bookmark.i_del_flg]];
    } else {
        insert_flg = [db.connection executeUpdate:@"INSERT INTO BOOKMARK \
                (t_title,t_place,r_latitude,r_longitude,d_start_date,r_start_time,r_end_time,i_base_service,t_url,d_insert,i_del_flg) \
                VALUES (?,?,?,?,?,?,?,?,?)",
                bookmark.t_title,bookmark.t_place,
                [NSNumber numberWithDouble:bookmark.r_latitude],
                [NSNumber numberWithDouble:bookmark.r_longitude],
                [NSNumber numberWithLong:[[bookmark.d_start_date truncWithScale:NSDayCalendarUnit] timeIntervalSince1970]],
                [NSNumber numberWithDouble:bookmark.r_start_time],
                [NSNumber numberWithDouble:bookmark.r_end_time],
                [NSNumber numberWithInt:bookmark.i_base_service],
                bookmark.t_url,
                [NSNumber numberWithLong:[bookmark.d_insert timeIntervalSince1970]],
                [NSNumber numberWithInt:bookmark.i_del_flg]];
    }
    [db hadError];
    [db commit];
    
    if (insert_flg) {
        //set i_id from table
        FMResultSet *rs = [db.connection executeQuery:@"SELECT i_id FROM BOOKMARK WHERE i_del_flg = 0 ORDER BY i_id DESC LIMIT 1"];
        [db hadError];
        
        if ([rs next]) {
            bookmark.i_id = [rs intForColumn:@"i_id"];
        }
    }
    
    return insert_flg;
}

+(bool)update:(Bookmark*)bookmark {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool update_flg = false;
    
    if (bookmark.d_end_date != nil) {
        update_flg = [db.connection executeUpdate:@"UPDATE BOOKMARK SET \
                      t_title=?, t_place=?, r_latitude=?, r_longitude=?, d_start_date=?, d_end_date=?, r_start_time=?, r_end_time=?, i_base_service=?, t_url=? \
                      WHERE i_id = ?",
                      bookmark.t_title,bookmark.t_place,
                      [NSNumber numberWithDouble:bookmark.r_latitude],
                      [NSNumber numberWithDouble:bookmark.r_longitude],
                      [NSNumber numberWithLong:[[bookmark.d_start_date truncWithScale:NSDayCalendarUnit] timeIntervalSince1970]],
                      [NSNumber numberWithLong:[[bookmark.d_end_date truncWithScale:NSDayCalendarUnit] timeIntervalSince1970]],
                      [NSNumber numberWithDouble:bookmark.r_start_time],
                      [NSNumber numberWithDouble:bookmark.r_end_time],
                      [NSNumber numberWithInt:bookmark.i_base_service],
                      bookmark.t_url,
                      [NSNumber numberWithInt:bookmark.i_id]];
    } else {
        update_flg = [db.connection executeUpdate:@"UPDATE BOOKMARK SET \
                      t_title=?, t_place=?, r_latitude=?, r_longitude=?, d_start_date=?, r_start_time=?, r_end_time=?, i_base_service=?, t_url=? \
                      WHERE i_id = ?",
                      bookmark.t_title,bookmark.t_place,
                      [NSNumber numberWithDouble:bookmark.r_latitude],
                      [NSNumber numberWithDouble:bookmark.r_longitude],
                      [NSNumber numberWithLong:[[bookmark.d_start_date truncWithScale:NSDayCalendarUnit] timeIntervalSince1970]],
                      [NSNumber numberWithDouble:bookmark.r_start_time],
                      [NSNumber numberWithDouble:bookmark.r_end_time],
                      [NSNumber numberWithInt:bookmark.i_base_service],
                      bookmark.t_url,
                      [NSNumber numberWithInt:bookmark.i_id]];
    }
    [db hadError];
    //[db commit];
    
    return update_flg;
}

+(NSMutableArray*)selectAll{
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* bookmarkArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM BOOKMARK WHERE i_del_flg = 0 ORDER BY i_id ASC"];
    [db hadError];
    
    while([rs next]) {
        Bookmark *bm = [[Bookmark alloc] initWithResultSet:rs];
        
        [bookmarkArray addObject:bm];
    }
    
    return bookmarkArray;
}

+(bool)deleteWithId:(Bookmark*)bookmark {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool delete_flg = false;
    
    delete_flg =  [db.connection executeUpdate:@"DELETE FROM BOOKMARK WHERE i_id = ?",
                   [NSNumber numberWithInt:bookmark.i_id]];
    [db hadError];
    [db commit];
    
    return delete_flg;
}

+(NSMutableArray*)selectWithCondition:(SearchCondition*)cond {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray *bookmarkArray = [NSMutableArray new];
    
    //FIXME: temporary logic
    //bookmarkArray = [BookmarkDAO selectAll];
    CGFloat latLongRadius = [BookmarkDAO convertMeterToLatLong:cond.searchAreaRadius];
    // if cannot get correct radius, set no limit radius
    if (latLongRadius <= 0.0f) {
        latLongRadius = 180;
    }
    NSDate *targetDate = [NSDate dateWithTimeInterval:0 sinceDate:cond.bookmark.d_start_date];
    
    while ([targetDate timeToDate:cond.bookmark.d_end_date scale:NSDayCalendarUnit] >= 0) {
        FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM BOOKMARK \
                           WHERE i_del_flg = 0 \
                           AND d_start_date <= ? \
                           AND d_end_date >= ? \
                           AND r_latitude BETWEEN ? AND ? \
                           AND r_longitude BETWEEN ? AND ? \
                           ORDER BY (d_end_date - d_start_date), (r_end_time - r_start_time) ASC",
                           [NSNumber numberWithLong:[[targetDate truncWithScale:NSDayCalendarUnit] timeIntervalSince1970]],
                           [NSNumber numberWithLong:[[targetDate truncWithScale:NSDayCalendarUnit] timeIntervalSince1970]],
                           [NSNumber numberWithDouble:cond.bookmark.r_latitude - latLongRadius],[NSNumber numberWithDouble:cond.bookmark.r_latitude + latLongRadius],
                           [NSNumber numberWithDouble:cond.bookmark.r_longitude - latLongRadius],[NSNumber numberWithDouble:cond.bookmark.r_longitude + latLongRadius]
                           ];
        [db hadError];
        
        NSMutableArray* bookmarksWithDate = [NSMutableArray new];
        while([rs next]) {
            Bookmark *bm = [[Bookmark alloc] initWithResultSet:rs];
            
            // set start/end date for showing as sticky
            bm.d_start_date = [NSDate dateWithTimeInterval:0 sinceDate:targetDate];
            bm.d_end_date = [NSDate dateWithTimeInterval:0 sinceDate:targetDate];
            
            [bookmarksWithDate addObject:bm];
        }
        
        [bookmarkArray addObject:bookmarksWithDate];
        
        targetDate = [targetDate addDay:1];
    }

    
    return bookmarkArray;
}

//TODO: move below method to correct class or category
+(CGFloat)convertMeterToLatLong:(NSInteger)meter {
    CGFloat latLong = 0.0f;
    
    latLong = (CGFloat)meter * 360 / (40076.5 * 1000);
    
    return latLong;
}

@end
