//
//  BookmarkDAO.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "BookmarkDAO.h"

@implementation BookmarkDAO

+(bool)insert:(Bookmark*)bookmark {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool insert_flg = false;
    
    bookmark.d_insert = [NSDate date];
    
    if (bookmark.d_end_date != nil) {
        insert_flg = [db.connection executeUpdate:@"INSERT INTO BOOKMARK \
                (t_title,t_place,r_latitude,r_longitude,d_start_date,d_end_date,i_base_service,t_url,d_insert,i_del_flg) \
                VALUES (?,?,?,?,?,?,?,?,?,?)",
                bookmark.t_title,bookmark.t_place,
                [NSNumber numberWithDouble:bookmark.r_latitude],
                [NSNumber numberWithDouble:bookmark.r_longitude],
                [NSNumber numberWithLong:[bookmark.d_start_date timeIntervalSince1970]],
                [NSNumber numberWithLong:[bookmark.d_end_date timeIntervalSince1970]],
                [NSNumber numberWithInt:bookmark.i_base_service],
                bookmark.t_url,
                [NSNumber numberWithLong:[bookmark.d_insert timeIntervalSince1970]],
                [NSNumber numberWithInt:bookmark.i_del_flg]];
    } else {
        insert_flg = [db.connection executeUpdate:@"INSERT INTO BOOKMARK \
                (t_title,t_place,r_latitude,r_longitude,d_start_date,i_base_service,t_url,d_insert,i_del_flg) \
                VALUES (?,?,?,?,?,?,?,?,?)",
                bookmark.t_title,bookmark.t_place,
                [NSNumber numberWithDouble:bookmark.r_latitude],
                [NSNumber numberWithDouble:bookmark.r_longitude],
                [NSNumber numberWithDouble:[bookmark.d_start_date timeIntervalSince1970]],
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
                      t_title=?, t_place=?, r_latitude=?, r_longitude=?, d_start_date=?, d_end_date=?, i_base_service=?, t_url=? \
                      WHERE i_id = ?",
                      bookmark.t_title,bookmark.t_place,
                      [NSNumber numberWithDouble:bookmark.r_latitude],
                      [NSNumber numberWithDouble:bookmark.r_longitude],
                      [NSNumber numberWithLong:[bookmark.d_start_date timeIntervalSince1970]],
                      [NSNumber numberWithLong:[bookmark.d_end_date timeIntervalSince1970]],
                      [NSNumber numberWithInt:bookmark.i_base_service],
                      bookmark.t_url,
                      [NSNumber numberWithInt:bookmark.i_id]];
    } else {
        update_flg = [db.connection executeUpdate:@"UPDATE BOOKMARK SET \
                      t_title=?, t_place=?, r_latitude=?, r_longitude=?, d_start_date=?, i_base_service=?, t_url=? \
                      WHERE i_id = ?",
                      bookmark.t_title,bookmark.t_place,
                      [NSNumber numberWithDouble:bookmark.r_latitude],
                      [NSNumber numberWithDouble:bookmark.r_longitude],
                      [NSNumber numberWithLong:[bookmark.d_start_date timeIntervalSince1970]],
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

@end
