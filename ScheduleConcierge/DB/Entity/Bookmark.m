//
//  Bookmark.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "Bookmark.h"
#import "NSString+Validate.h"

@implementation Bookmark

+(Bookmark*)bookmarkWithBookmark:(Bookmark*)bm {
    if(bm == nil || [bm.t_title isEmpty]) return nil;
    
    Bookmark *bookmark = [[Bookmark alloc] initWithTitle:[NSString stringWithString:bm.t_title]];
    if (![bm.t_place isEmpty]) {
        bookmark.t_place = [NSString stringWithString:bm.t_place];
    }
    if (![bm.t_url isEmpty]) {
        bookmark.t_url = [NSString stringWithString:bm.t_url];
    }
    
    bookmark.i_id = bm.i_id;
    bookmark.r_latitude = bm.r_latitude;
    bookmark.r_longitude = bm.r_longitude;
    bookmark.d_start_date = bm.d_start_date;
    bookmark.d_end_date = bm.d_end_date;
    bookmark.i_base_service = bm.i_base_service;
    bookmark.i_del_flg = 0;
    
    return bookmark;
}

-(id)initWithTitle:(NSString*)title {
    
    if (self = [super init]) {
        self.t_title = title;
        self.t_place = @"";
        self.t_url = @"";
        self.r_latitude = 0.0f;
        self.r_longitude = 0.0f;
        self.d_start_date = [NSDate date];
        self.d_end_date = nil;
        self.i_base_service = -1;
        self.i_del_flg = 0;
    }
    
    return self;
}

-(id)initWithResultSet:(FMResultSet*)rs {
    if (self = [super init]) {
        self.i_id = [rs intForColumn:@"i_id"];
        self.t_title = [rs stringForColumn:@"t_title"];
        self.t_place = [rs stringForColumn:@"t_place"];
        self.r_latitude = [rs doubleForColumn:@"r_latitude"];
        self.r_longitude = [rs doubleForColumn:@"r_latitude"];
        self.d_start_date = [NSDate dateWithTimeIntervalSince1970:[rs longForColumn:@"d_start_date"]];
        self.d_end_date = [NSDate dateWithTimeIntervalSince1970:[rs longForColumn:@"d_end_date"]];
        self.i_base_service = [rs intForColumn:@"i_base_service"];
        
        if (![[rs stringForColumn:@"t_url"] isEmpty]) {
           self.t_url = [rs stringForColumn:@"t_url"]; 
        } else {
            self.t_url = @"";
        }
        
        self.d_insert = [NSDate dateWithTimeIntervalSince1970:[rs longForColumn:@"d_insert"]];
    }
    
    return self;
}

@end
