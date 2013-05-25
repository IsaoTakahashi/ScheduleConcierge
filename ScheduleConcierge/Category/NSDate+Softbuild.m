//
//  NSDate+Softbuild.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "NSDate+Softbuild.h"

@implementation NSDate (Softbuild)

- (NSInteger) weekday {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    return comps.weekday;
}

- (NSString*) stringShortweekday {
    static NSString* const array[] = {nil, @"日", @"月", @"火", @"水", @"木", @"金", @"土"};
    NSInteger index = [self weekday];
    if (index > 7) index = 0;
    return array[index];
}

- (NSString*) stringShortweekdayEn {
    static NSString* const array[] = {nil, @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"};
    NSInteger index = [self weekday];
    if (index > 7) index = 0;
    return array[index];
}

- (NSDate*) tommorow {
    return [self addDay:1];
}
- (NSDate*) yesterday {
    return [self subDay:1];
}

- (NSDate*) addDay:(int)day {
    return [NSDate dateWithTimeInterval:day*24*60*60 sinceDate:self];
}
- (NSDate*) subDay:(int)day {
    return [self addDay:-day];
}

@end
