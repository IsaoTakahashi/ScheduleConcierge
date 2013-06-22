//
//  StickyManager.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "StickyManager.h"
#import "BookmarkDAO.h"

#define SERIAL_FIRST_NUM 1


static StickyManager *singlton;

@interface StickyManager()
- (StickyManager*) init;
@end

@implementation StickyManager

+ (StickyManager *)getInstance {
    if (singlton == nil) {
        singlton = [[StickyManager alloc] init];
    }
    
    return singlton;
}

- (StickyManager*) init {
    if(self = [super init]) {
        self.stikcySerial = SERIAL_FIRST_NUM;
        self.stickyCtrArray = [NSMutableArray new];
        self.dateBarCtrArray = [NSMutableArray new];
        self.stickyArray = [NSMutableArray new];
        self.dateBarArray = [NSMutableArray new];
    }
    
    return self;
}

-(Boolean)addDateBar:(DateBarViewController*)dbvCtr {
    if ([self.dateBarArray containsObject:dbvCtr.view]) {
        return false;
    }
    
    [self.dateBarArray addObject:dbvCtr.view];
    [self.dateBarCtrArray addObject:dbvCtr];
    
    return true;
}

-(Boolean)addSticky:(UIStickyViewController*)usvCtr {
    UIStickyView *stickyView = (UIStickyView*)usvCtr.view;
    if ([self.stickyArray containsObject:stickyView]) {
        return false;
    }
    
    [stickyView initialize];
    
    usvCtr.view.tag = self.stikcySerial++;
    [self.stickyArray addObject:stickyView];
    [self.stickyCtrArray addObject:usvCtr];
    
    return true;
}

-(Boolean)addStickyWithBookmark:(Bookmark*)bm usvCtr:(UIStickyViewController*)usvCtr {
    
    UIStickyView *stickyView = (UIStickyView*)usvCtr.view;
    if ([self.stickyArray containsObject:stickyView]) {
        return false;
    }
    
    [stickyView initializeWithBookmark:bm];
    
    usvCtr.view.tag = self.stikcySerial++;
    [self.stickyArray addObject:stickyView];
    [self.stickyCtrArray addObject:usvCtr];
    
    return true;
}

-(Boolean)removeStickyWithTag:(NSInteger)tag {
    UIStickyViewController *targetCtr = nil;
    
    for (UIView *view in self.stickyArray) {
        if(view.tag == tag) {
            for (DateBarViewController* dbvCtr in self.dateBarCtrArray) {
                if ([dbvCtr.stickies containsObject:view]) {
                    UIStickyView *stickyView = (UIStickyView*)view;
                    [dbvCtr removeSticky:stickyView];
                    [dbvCtr sortStickies];
                }
            }
            
            // 配列から除外し、どのViewからも排除する(見えなくなる)
            [self.stickyArray removeObject:view];
            [view removeFromSuperview];
            
            for (UIStickyViewController *usvCtr in self.stickyCtrArray) {
                if ([usvCtr.view isEqual:view]) {
                    targetCtr = usvCtr;
                    break;
                }
            }
            
            if (targetCtr != nil) {
                [self.stickyCtrArray removeObject:targetCtr];
            }
            return true;
        }
    }
    
    return false;
}

-(Boolean)relocateSticky:(UIStickyView*)stickyView {
    CGRect viewCenterRect = CGRectMake(stickyView.center.x, stickyView.center.y, 1.0, 1.0);
    DateBarViewController *prevCtr = nil;
    
    // remove Sticky from current DateBar
    for (DateBarViewController *dbvCtr in self.dateBarCtrArray) {
        if ([stickyView.superview isEqual:dbvCtr.view]) {
            prevCtr = dbvCtr;
            break;
        }
    }
    
    for (DateBarViewController *dbvCtr in self.dateBarCtrArray) {
        NSLog(@"%@ : %@",dbvCtr.DateLabel.text,NSStringFromCGRect(dbvCtr.view.frame));
        NSLog(@"%@ : %@",stickyView.nameLabel.text,NSStringFromCGRect(viewCenterRect));
        if (CGRectIntersectsRect(dbvCtr.view.frame, [stickyView.superview convertRect:viewCenterRect toView:dbvCtr.view.superview])) {
            if (prevCtr != nil) {
                [prevCtr removeSticky:stickyView];
            }
            
            [dbvCtr addSticky:stickyView];
            [self sortAllDateBar];
            return true;
        }
    }
    
    [self sortAllDateBar];
    
    return false;
}

-(void)sortAllDateBar {
    for (DateBarViewController *dbvCtr in self.dateBarCtrArray) {
        [dbvCtr sortStickies];
    }
}
@end
