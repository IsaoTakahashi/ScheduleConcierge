//
//  Bookmark.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

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
        self.d_insert = [NSDate dateWithTimeIntervalSince1970:[rs longForColumn:@"d_insert"]];
    }
    
    return self;
}

@end
