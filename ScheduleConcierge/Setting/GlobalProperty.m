//
//  GlobalProperty.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "GlobalProperty.h"

static GlobalProperty *singlton;

@interface GlobalProperty()
- (GlobalProperty*) init;
@end

@implementation GlobalProperty

+ (GlobalProperty *)getInstance {
    if (singlton == nil) {
        singlton = [[GlobalProperty alloc] init];
    }
    
    return singlton;
}

- (GlobalProperty*) init {
    if(self = [super init]) {
        self.directionType = UNDEFINED;
        self.offsetType = OFFSET_OFF;
    }
    
    return self;
}

@end
