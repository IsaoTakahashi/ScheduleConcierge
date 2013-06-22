//
//  PlaceSearchLogic.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceSearchLogic : NSObject

@property (weak,nonatomic) NSString *searchWord;

-(id)initWithSearchWord:(NSString*)word;
-(NSDictionary*)searchPlaceURL;
@end
