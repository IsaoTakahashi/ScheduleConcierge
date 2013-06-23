//
//  UIStickyView.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/04/30.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "UIStickyView.h"
#import "MBProgressHUD.h"
#import "GlobalProperty.h"
#import "StickyManager.h"
#import "NSString+URLEncoding.h"
#import "BookmarkDAO.h"

@implementation UIStickyView

- (void)initialize {
    
    [self registerRecognizers];
    [self setStyle];
    
    // Set Information for Outlet
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"create sticky" message:@"input search word" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"search", nil];
    alert.tag = CREATE;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    
    self.nameLabel.text = @"?";
}

- (void)initializeWithBookmark:(Bookmark*)bm {
    [self registerRecognizers];
    [self setStyle];
    
    self.bookmark = bm;
    
    self.nameLabel.text = bm.t_title;
    
    [self loadImage];
    
    //insert data if id doesn't exist
    if (self.bookmark.i_id <= 0) {
        [BookmarkDAO insert:self.bookmark];
    }
}

- (void)setStyle {
    self.layer.borderColor = [[UIColor brownColor] CGColor];
}

-(void)registerRecognizers {
    // Set GestureRecognizer
    UIPanGestureRecognizer *recogPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSticky:)];
    [self addGestureRecognizer:recogPan];
    UILongPressGestureRecognizer *recogLong = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removeStickyAlert:)];
    [self addGestureRecognizer:recogLong];
    UITapGestureRecognizer *recogDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapSticky:)];
    recogDoubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:recogDoubleTap];
    
}

-(void)loadImage {
    
    NSString *searchText;
    ImageSearchLogic *imageSearchLogic;
    NSURL *imageURL;
    SimpleNetwork *simpleNetwork = [SimpleNetwork new];
    simpleNetwork.delegate = self;
    
    searchText = self.nameLabel.text;
    imageSearchLogic = [[ImageSearchLogic alloc] initWithSearchWord:searchText];
    imageURL = [imageSearchLogic searchImageURL];
    
    [MBProgressHUD showHUDAddedTo:self.resultImageView animated:YES];
    [simpleNetwork sendGetRequestForData:imageURL tag:@"aaa"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark UIAlertViewDelegate

// enable "search" button when any text is input
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if(alertView.tag == CREATE) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if(inputText.length > 0){
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CREATE) {
        
        switch (buttonIndex) {
            case 1:
                self.nameLabel.text = [[alertView textFieldAtIndex:0] text];
                [self loadImage];
                self.bookmark = [[Bookmark alloc] initWithTitle:self.nameLabel.text];
                [BookmarkDAO insert:self.bookmark];
                
                break;
                
            default:
                break;
        }
    } else if (alertView.tag == REMOVE) {
        switch (buttonIndex) {
            case 1:
                //[self removeFromSuperview];
                [BookmarkDAO deleteWithId:self.bookmark];
                [[StickyManager getInstance] removeStickyWithTag:self.tag];
                break;
            default:
                break;
        }
        
    }
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
            [self.superview.superview bringSubviewToFront:self.superview];
            [self.superview bringSubviewToFront:self];
            
            lastPoint_ = [recog locationOfTouch:0 inView:self.superview];
            self.springAnimationLogic = [[SpringAnimationLogic alloc] initWithTarget:self effectedViewArray:[StickyManager getInstance].stickyArray];
            [self setSpringAnimationSetting];
            
            if(![self.springAnimationLogic prepareAnimation]) {
                NSLog(@"faled to Preparation");
            }
            break;
        case UIGestureRecognizerStateChanged:
            nowPoint = [recog locationOfTouch:0 inView:self.superview];
            [self setViewPosition:CGPointMake(nowPoint.x - lastPoint_.x, nowPoint.y - lastPoint_.y)];            
            lastPoint_ = nowPoint;
            
            if ([self.springAnimationLogic executeAnimation]) {
                //NSLog(@"Moved!!");
            } else {
                //NSLog(@"faled to Moving");
            }
            break;
        case UIGestureRecognizerStateEnded:
            if ([self.springAnimationLogic stopAnimation]) {
                NSLog(@"Stop SpringAnimation normally");
            }
            //TODO: DateBarに入れてソートしたいね
            [[StickyManager getInstance] relocateSticky:self];
            break;
        default:
            if ([self.springAnimationLogic stopAnimation]) {
                NSLog(@"Stop SpringAnimation normally");
            }
            break;
            
    }
}

-(void)removeStickyAlert:(UILongPressGestureRecognizer*)recog {
    UIAlertView* removeAlert;
    
    switch (recog.state) {
        case UIGestureRecognizerStateBegan:
            removeAlert = [[UIAlertView alloc] initWithTitle:@"Remove Sticky" message:@"Do you want to remove?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            removeAlert.tag = REMOVE;
            [removeAlert setAlertViewStyle:UIAlertViewStyleDefault];
            [removeAlert show];
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
        default:
            break;
    }
}

-(void)doubleTapSticky:(UITapGestureRecognizer*)recog {
    switch (recog.state) {
        case UIGestureRecognizerStateEnded:
            //TODO: call BookingSettingViewController
            [self.delegate beginSetting:self];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark SimpleNetWorkDelegate
-(void)receiveResponseResult:(NSHTTPURLResponse *)responseHeader responseString:(NSString *)responseString tag:(NSString *)tag {
    if (responseHeader.statusCode != 200) {
        NSLog(@"received status code: %d",responseHeader.statusCode);
        return;
    }
    
    NSData *resultData = (NSData*)responseString;
    [self setImageData:resultData];
}

-(void)receiveResponseResultWithDataRequest:(NSHTTPURLResponse *)responseHeader responseData:(NSData *)responseData tag:(NSString *)tag {
    
    [MBProgressHUD hideHUDForView:self.resultImageView animated:YES];
    
    if (responseHeader == nil || responseHeader.statusCode != 200) {
        NSLog(@"received status code: %d",responseHeader.statusCode);
        return;
    }
    
    [self setImageData:responseData];
}

#pragma mark -
#pragma mark private method

-(void)setViewPosition:(CGPoint)diffVector
{
    CGPoint center = self.center;
    center.x += diffVector.x;
    center.y += diffVector.y;
    
    self.center = center;
}

-(void) setSpringAnimationSetting {
    if (self.springAnimationLogic != nil) {
        GlobalProperty *gp = [GlobalProperty getInstance];
        
        self.springAnimationLogic.directionType = gp.directionType;
        self.springAnimationLogic.offsetType = gp.offsetType;
        self.springAnimationLogic.springConstant = 1000.0f;
        self.springAnimationLogic.repulsionConst = 0.001f;
    }
}

-(void)setImageData:(NSData*)imageData {
    if (imageData == nil) return;
    NSLog(@"set Image");
    self.resultImageView.image = [UIImage imageWithData:imageData scale:0.5];
}

@end
