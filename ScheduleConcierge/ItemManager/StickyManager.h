//
//  StickyManager.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateBarViewController.h"
#import "UIStickyViewController.h"
#import "Bookmark.h"

@interface StickyManager : NSObject

@property (nonatomic) int stikcySerial;
@property (strong,nonatomic) NSMutableArray *stickyCtrArray;
@property (strong,nonatomic) NSMutableArray *dateBarCtrArray;
@property (strong,nonatomic) NSMutableArray *stickyArray;
@property (strong,nonatomic) NSMutableArray *dateBarArray;

+(StickyManager*)getInstance;

-(Boolean)addDateBar:(DateBarViewController*)dbvCtr;
-(Boolean)addSticky:(UIStickyViewController*)usvCtr;
-(Boolean)addStickyWithBookmark:(Bookmark*)bm usvCtr:(UIStickyViewController*)usvCtr;

-(Boolean)removeStickyWithTag:(NSInteger)tag;

-(Boolean)relocateSticky:(UIStickyView*)stickyView;
@end
