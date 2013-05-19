//
//  ImageSearchLogic.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/19.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "ImageSearchLogic.h"

@implementation ImageSearchLogic

static NSString * const IMAGE_API_URL = @"http://ajax.googleapis.com/ajax/services/search/images";//?q=%@&v=1.0";

- (id)initWithSearchWord:(NSString *)word {
    
    if(self = [super init]) {
        self.searchWord = word;
    }
    
    return self;
}

- (NSURL*)searchImageURL {
    NSDictionary* jsonObject = [self requestJsonObjectBySearch];
    NSArray *searchResultArray = [jsonObject valueForKeyPath:@"responseData.results"];
    
    // if can't get any result, return dummy URL
    if(searchResultArray == nil) {
        return [NSURL URLWithString:@"http://travel.rakuten.co.jp"];
    }
    
    NSDictionary *firstResultDictionary = searchResultArray[0];
    NSString *firstResultURLString = [firstResultDictionary valueForKey:@"url"];
    //NSArray* resultArray = [searchResultDictionary allValues];
    NSLog(@"resultURL = %@",firstResultURLString);
    return [NSURL URLWithString:firstResultURLString];
}

#pragma mark -
#pragma mark Search Logic

- (NSDictionary*) requestJsonObjectBySearch {
    NSString *searchURLString = [NSString stringWithFormat:@"%@?q=%@&v=1.0&hl=ja",IMAGE_API_URL,self.searchWord];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchURLString]];
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"jsonObject =%@",[jsonObject description]);
    return jsonObject;
}


@end
