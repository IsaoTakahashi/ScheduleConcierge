//
//  TripSuggestionLogic.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/24.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "TripSuggestionLogic.h"
#import "BookmarkDAO.h"

@implementation TripSuggestionLogic

+(NSMutableArray*)suggestionWithCondition:(SearchCondition*)cond {
    NSMutableArray* matchedBMArray = [BookmarkDAO selectWithCondition:cond];
    
    NSMutableArray* refinedBMArray = [TripSuggestionLogic refineBookmarks:matchedBMArray condition:cond];
    
    return refinedBMArray;
}

+(NSMutableArray*)refineBookmarks:(NSMutableArray*)baseArray condition:(SearchCondition*)cond {
    NSMutableArray* refinedArray = [NSMutableArray new];
    NSMutableArray* usedBookmarks = [NSMutableArray new];
    
    for (NSMutableArray *bookmarkWithDate in baseArray) {
        NSMutableArray *useBookmarkWithDate = [NSMutableArray new];
        
        //重複を排除する
        for (Bookmark *bm in bookmarkWithDate) {
            if ([bm isContainedInArray:usedBookmarks]) continue;
            
            [useBookmarkWithDate addObject:bm];
        }
        
        //検索条件の時間内で、観光可能なBookmarkを抽出する
        NSMutableArray *timeLinedBookmarks = [TripSuggestionLogic selectBookmarkOnTimelineFrom:cond.bookmark.r_start_time To:cond.bookmark.r_end_time targetBookmarks:useBookmarkWithDate];
        
        [usedBookmarks addObjectsFromArray:timeLinedBookmarks];
        
        
        [refinedArray addObject:timeLinedBookmarks];
    }
    
    return refinedArray;
}

+(NSMutableArray*)selectBookmarkOnTimelineFrom:(int)startTime To:(int)endTime targetBookmarks:(NSMutableArray*)bookmarks {
    NSMutableArray *timeArray = [NSMutableArray new];
    NSMutableArray *selectedArray = [NSMutableArray new];
    
    //時間ブロックの配列を初期化
    for (int i=0;i<endTime-startTime; i++) {
        [timeArray addObject:[NSString stringWithFormat:@""]];
    }
    
    //対象のBookmarkが、観光可能かチェック
    for (Bookmark *bm in bookmarks) {
        NSInteger stayTime = 2; //default
        if (bm.r_end_time - bm.r_start_time < stayTime) {
            stayTime = (NSInteger)(bm.r_end_time - bm.r_start_time);
        }
        
        NSInteger targetStartTime = (NSInteger)bm.r_start_time;
        if (targetStartTime < startTime) targetStartTime = startTime;
        
        //Bookmarkの開始時間が検索対象の終了時間以降の場合、諦める
        if (endTime <= targetStartTime) continue;
        
        for (int j=targetStartTime-startTime;(j<timeArray.count - (stayTime-1)) && (startTime+j < bm.r_end_time);j++) {
            bool isStayable = true;
            
            //stayTimeの時間分の空きがあるかどうかをチェック
            for (int k=j;k<j+stayTime;k++) {
                NSString *timeString = timeArray[k];
                if ([timeString isEmpty]) {
                    continue;
                } else {
                    isStayable = false;
                    break;
                }
            }
            
            if(isStayable) {
                //StayTimeの期間だけ時間を埋める
                for (int l=j;l<j+stayTime;l++) {
                    timeArray[l] = @"-";
                }
                
                //bmにStartTimeとEndTimeをセット
                bm.r_start_time = startTime + j;
                bm.r_end_time = bm.r_start_time + stayTime;
                [selectedArray addObject:bm];
                break;
            }
            
        }
    }
    
    //TODO: Bookmark を到着時間順にソート
    NSSortDescriptor *sortStartTime = [[NSSortDescriptor alloc] initWithKey:@"r_start_time" ascending:YES];
    NSArray *sortDescArray = [NSArray arrayWithObject:sortStartTime];
    
    selectedArray = [NSMutableArray arrayWithArray:[selectedArray sortedArrayUsingDescriptors:sortDescArray]];
    
    return selectedArray;
}

@end
