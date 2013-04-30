//
//  SimpleDBManagerTest.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SimpleDBManager.h"

@interface SimpleDBManagerTest : SenTestCase
{
    SimpleDBManager *instance;
}

- (void)testGetInstance;

@end
