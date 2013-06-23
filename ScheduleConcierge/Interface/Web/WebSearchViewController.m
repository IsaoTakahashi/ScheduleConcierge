//
//  WebSearchViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/23.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "WebSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+URLEncoding.h"
#import "NSString+Validate.h"
#import "MBProgressHUD.h"

@interface WebSearchViewController ()

@end

static const NSString *baseURLString = @"https://www.google.co.jp/search";

@implementation WebSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self viewSetting];
        self.webView.delegate = self;
    }
    return self;
}

-(void)initializeWithBookmark:(Bookmark*)bm {
    self.bookmark = bm;
    
    if (self.bookmark.i_base_service <= 0) {
        self.bsType = NONE;
    } else {
        self.bsType = self.bookmark.i_base_service;
    }
    
    self.searchBar.text = self.bookmark.t_title;
    
    if (![self.bookmark.t_url isEmpty]) {
        [self searchOnWebViewWithURL:[NSURL URLWithString:self.bookmark.t_url]];
    } else if (![self.searchBar.text isEmpty]) {
        [self searchOnWebView:self.bsType];
    }
}

-(void)viewSetting {
    CALayer *layer = self.view.layer;
    
    // shadow setting
    layer.shadowRadius = 5;
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOpacity = 0.5;
    layer.shadowOffset = CGSizeMake(1, 3);
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    // corner setting
    layer.cornerRadius = 5;
    layer.borderWidth = 3;
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
}

-(void)searchOnWebViewWithURL:(NSURL*)url {
    if (url != nil) {
        [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

-(void)searchOnWebView:(BookmarkServiceType)type {
    NSURL *url = nil;
    
    switch (type) {
        case NONE:
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?q=%@",baseURLString,[self.searchBar.text escapedString]]];
            break;
        case FACEBOOK:
            break;
        case TWITTER:
            break;
        case HATENA:
            break;
        default:
            break;
    }
    
    [self searchOnWebViewWithURL:url];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark SearchBar Delegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self searchOnWebView:self.bsType];
}

-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    NSString* title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString* url = [self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    self.bookmark.t_title = title;
    self.bookmark.i_base_service = self.bsType;
    self.bookmark.t_url = url;
    
    [self.delegate selectedBookmarkURL:self.bookmark];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancel");
}

#pragma mark -
#pragma mark UIWebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

- (IBAction)clickedCancelButton:(id)sender {
    [self.delegate selectedBookmarkURL:nil];
}
@end
