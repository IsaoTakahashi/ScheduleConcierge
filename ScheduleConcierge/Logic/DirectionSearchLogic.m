//
//  DirectionSearchLogic.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "DirectionSearchLogic.h"

@implementation DirectionSearchLogic

static NSString * const DIRECTION_API_URL = @"http://maps.googleapis.com/maps/api/directions/json";

-(id)init {
    if (self =[super init]) {
        self.directionArray = [NSMutableArray new];
    }
    
    return self;
}

-(Boolean)searchDirections {
    if (self.directionArray.count == 0) return false;
    
    for (Direction *dir in self.directionArray) {
        NSDictionary *directionResuleDic = [self requestJsonObjectBySearch:dir];
        
        if (directionResuleDic == nil || ![directionResuleDic[@"status"] isEqual:@"OK"]) continue;
        
        NSArray *routesArray = directionResuleDic[@"routes"];
        NSArray *legsArray = routesArray[0][@"legs"];
        
        if (legsArray == nil || legsArray.count == 0) return false;
        
        
        NSDictionary* firstDirection = legsArray[0];
        NSNumber *distance = firstDirection[@"distance"][@"value"];
        NSNumber *duration = firstDirection[@"duration"][@"value"];
        
        dir.distance = distance;
        dir.destinationTime = [NSDate dateWithTimeInterval:[duration doubleValue] sinceDate:dir.departureTime];
    }
    
    return true;
}

-(NSDictionary*)requestJsonObjectBySearch:(Direction*)dir {
    
    //TODO: とりあえず1個のDirectionインスタンス(2点間の経路)だけ検索できる仕様
    if (dir == nil) return nil;
    
    NSString *searchURLString = [NSString stringWithFormat:@"%@?origin=%@&destination=%@&departure_time=%f&sensor=false",
                                 DIRECTION_API_URL,
                                 [dir.departurePlace escapedString],
                                 [dir.destinationPlace escapedString],
                                 [dir.departureTime timeIntervalSince1970]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchURLString]];
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error = nil;
    NSDictionary *jsonObject = nil;
    
    if (jsonData != nil) {
        jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"jsonObject =%@",[jsonObject description]);
    } else {
        NSLog(@"cann't get jsonObject");
    }
    
    return jsonObject;
}

@end
