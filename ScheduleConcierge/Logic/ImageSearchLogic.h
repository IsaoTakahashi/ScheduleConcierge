//
//  ImageSearchLogic.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/19.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSearchLogic : NSObject  {
}

@property (weak,nonatomic) NSString *searchWord;
@property (weak,nonatomic) NSMutableArray *hitImageURLArray;
@property (strong,nonatomic) UIImage* priorImage;

-(id)initWithSearchWord:(NSString*)word;
-(NSURL*)searchImageURL;
-(NSData*)requestImage:(NSURL*)url;

@end
