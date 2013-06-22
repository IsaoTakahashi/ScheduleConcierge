//
//  PlaceSearchLogic.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "PlaceSearchLogic.h"
#import "NSString+URLEncoding.h"

@implementation PlaceSearchLogic

static NSString * const PLACE_API_URL = @"https://maps.googleapis.com/maps/api/place/textsearch/json";

-(id)initWithSearchWord:(NSString *)word {
    
    if(self = [super init]) {
        self.searchWord = word;
    }
    
    return self;
}

-(NSDictionary*)searchPlaceURL {
    NSDictionary* jsonObject = [self requestJsonObjectBySearch];
    
    //parse
    if (jsonObject != nil && [jsonObject valueForKeyPath:@"status"] != nil) {
        NSString* responseStatus = [jsonObject valueForKeyPath:@"status"];
        if(![responseStatus isEqualToString:@"OK"]) {
            return nil;
        }
        NSArray *searchResultArray = [jsonObject valueForKeyPath:@"results"];
        
        if(searchResultArray != nil) {
            NSDictionary *firstResultDictionary = searchResultArray[0];
            NSDictionary *location = [firstResultDictionary valueForKeyPath:@"geometry.location"];
            //NSArray* resultArray = [searchResultDictionary allValues];
            NSLog(@"resultLocation = %@",[location description]);
            return location;
        }
    }
    
    return nil;
}

-(NSDictionary*) requestJsonObjectBySearch {
    
    NSString *searchPlaceURLString = [NSString stringWithFormat:@"%@?sensor=true&query=%@&key=%@",PLACE_API_URL,[self.searchWord escapedString],@"AIzaSyA1Lf_RqT-S0-gzdt4YdrHADwO1ZKICgMU"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchPlaceURLString]];
    
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
