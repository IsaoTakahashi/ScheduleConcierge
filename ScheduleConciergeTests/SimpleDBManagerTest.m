//
//  SimpleDBManagerTest.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "SimpleDBManagerTest.h"

@implementation SimpleDBManagerTest

- (void)setUp
{
    [super setUp];
    instance = [SimpleDBManager getInstance];
}

- (void)testGetInstance
{
    STAssertEqualObjects([SimpleDBManager getInstance], instance, @"different instance");
}

@end
