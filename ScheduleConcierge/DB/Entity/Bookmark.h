//
//  Bookmark.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface Bookmark : NSObject

@property (nonatomic) int i_id;
@property (nonatomic) NSString* t_title;
@property (nonatomic) NSString* t_place;
@property (nonatomic) CGFloat r_latitude;
@property (nonatomic) CGFloat r_longitude;
@property (nonatomic) NSDate *d_start_date;
@property (nonatomic) NSDate *d_end_date;
@property (nonatomic) int i_base_service;
@property (nonatomic) NSString* t_url;
@property (nonatomic) NSDate* d_insert;
@property (nonatomic) int i_del_flg;

@property (nonatomic) CGFloat r_start_time;
@property (nonatomic) CGFloat r_end_time;

-(id)initWithTitle:(NSString*)title;
-(id)initWithResultSet:(FMResultSet*)rs;

+(Bookmark*)bookmarkWithBookmark:(Bookmark*)bm;

-(bool)isContainedInArray:(NSMutableArray*)array;
-(NSComparisonResult)compareByStartTime:(Bookmark*)bm;
@end
