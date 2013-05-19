//
//  UIStickyView.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "UIStickyView.h"

@implementation UIStickyView

@synthesize nameLabel;
@synthesize siteWebView;



- (void)initialize {
    // Set GestureRecognizer
    UIPanGestureRecognizer *recog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSticky:)];
    [self addGestureRecognizer:recog];
    
    [self setStyle];
    
    // Set Information for Outlet
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"create sticky" message:@"input search word" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"search", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    
    nameLabel.text = @"?";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Set GestureRecognizer
        UIPanGestureRecognizer *recog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSticky:)];
        [self addGestureRecognizer:recog];
        
        // Set Background color
        [self setBackgroundColor:[UIColor brownColor]];
    }
    return self;
}

- (void)setStyle {
    self.layer.borderColor = [[UIColor brownColor] CGColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) loadWebView:(NSURL*)url {
    [siteWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *searchText;
    ImageSearchLogic *imageSearchLogic;
    
    switch (buttonIndex) {
        case 1:
            nameLabel.text = [[alertView textFieldAtIndex:0] text];
            searchText = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                            kCFAllocatorDefault,
                                                                            (CFStringRef)nameLabel.text,
                                                                            NULL,
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                            kCFStringEncodingUTF8));
            //[self loadWebView:[NSString stringWithFormat:@"https://www.google.co.jp/search?tbm=isch&q=%@",searchText]];
            //[self loadWebView:[NSString stringWithFormat:IMAGE_API_URL,searchText]];
            imageSearchLogic = [[ImageSearchLogic alloc] initWithSearchWord:searchText];
            [self loadWebView:[imageSearchLogic searchImageURL]];
            break;
            
        default:
            break;
    }
}

// enable "search" button when any text is input
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if(inputText.length > 0){
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate
- (void) moveSticky:(UIPanGestureRecognizer*)recog
{
    // current tap point on superview
    CGPoint nowPoint;
    
    switch (recog.state)
    {
        case UIGestureRecognizerStateBegan:
            lastPoint_ = [recog locationOfTouch:0 inView:self.superview];
            break;
        case UIGestureRecognizerStateChanged:
            nowPoint = [recog locationOfTouch:0 inView:self.superview];
            [self setViewPosition:CGPointMake(nowPoint.x - lastPoint_.x, nowPoint.y - lastPoint_.y)];
            if(recog.numberOfTouches > 0)
            {
                //NSLog(@"handled %@",NSStringFromCGPoint([recog locationOfTouch:0 inView:self.superview]));
            }
            
            lastPoint_ = nowPoint;
            break;
        default:
            break;
            
    }
}

#pragma mark -
#pragma mark private method

- (void) setViewPosition:(CGPoint)diffVector
{
    CGPoint center = self.center;
    center.x += diffVector.x;
    center.y += diffVector.y;
    
    self.center = center;
}

@end
