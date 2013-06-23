//
//  WebSearchViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/23.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bookmark.h"

typedef enum BookmarkServiceType : NSUInteger {
    NONE,
    FACEBOOK,
    TWITTER,
    HATENA
} BookmarkServiceType;

@protocol WebSearchViewControllerDelegate <NSObject>

-(void)selectedBookmarkURL:(Bookmark*)bm;

@end

@interface WebSearchViewController : UIViewController<UISearchBarDelegate,UIWebViewDelegate>

@property (nonatomic) id<WebSearchViewControllerDelegate> delegate;
@property (nonatomic) Bookmark *bookmark;
@property (nonatomic) BookmarkServiceType bsType;

-(void)initializeWithBookmark:(Bookmark*)bm;

//Outlet
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


//Event
- (IBAction)clickedCancelButton:(id)sender;


@end
