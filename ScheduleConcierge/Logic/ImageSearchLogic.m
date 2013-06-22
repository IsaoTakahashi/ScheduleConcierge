//
//  ImageSearchLogic.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/19.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "ImageSearchLogic.h"
#import "NSString+URLEncoding.h"

@implementation ImageSearchLogic

static NSString * const IMAGE_API_URL = @"http://ajax.googleapis.com/ajax/services/search/images";

-(id)initWithSearchWord:(NSString *)word {
    
    if(self = [super init]) {
        self.searchWord = word;
    }
    
    return self;
}

-(NSURL*)searchImageURL {
    NSDictionary* jsonObject = [self requestJsonObjectBySearch];
    if (jsonObject != nil && [jsonObject valueForKeyPath:@"responseStatus"] != nil) {
         NSNumber *responseStatusValue = [jsonObject valueForKeyPath:@"responseStatus"];
        if([responseStatusValue intValue] != 200) {
            return nil;
        }
        NSArray *searchResultArray = [jsonObject valueForKeyPath:@"responseData.results"];
        
        if(searchResultArray != nil) {
            NSDictionary *firstResultDictionary = searchResultArray[0];
            NSString *firstResultURLString = [firstResultDictionary valueForKey:@"unescapedUrl"];
            //NSArray* resultArray = [searchResultDictionary allValues];
            NSLog(@"resultURL = %@",firstResultURLString);
            return [NSURL URLWithString:firstResultURLString];
        }
    }
    
    return nil;
}

#pragma mark -
#pragma mark Search Logic

-(NSDictionary*) requestJsonObjectBySearch {
    NSString *searchURLString = [NSString stringWithFormat:@"%@?q=%@&v=1.0&hl=ja",IMAGE_API_URL,[self.searchWord escapedString]];
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

-(NSData*)requestImage:(NSURL*)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    return result;
}


@end
