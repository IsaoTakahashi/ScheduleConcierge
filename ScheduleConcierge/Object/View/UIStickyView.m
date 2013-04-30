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

- (id)init{
    if ([super init]) {
        // Set GestureRecognizer
        UIPanGestureRecognizer *recog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSticky:)];
        [self addGestureRecognizer:recog];
        
        // Set Background color
        //[self setBackgroundColor:[UIColor brownColor]];
        self.layer.cornerRadius = 0.5f;
        self.layer.masksToBounds = YES;
        
        // Set Information for Outlet
        nameLabel.text = @"aaa";
    }
    
    return self;
}

- (void)initialize {
    // Set GestureRecognizer
    UIPanGestureRecognizer *recog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSticky:)];
    [self addGestureRecognizer:recog];
    
    // Set Background color
    //[self setBackgroundColor:[UIColor brownColor]];
    self.layer.cornerRadius = 0.5f;
    self.layer.masksToBounds = YES;
    
    // Set Information for Outlet
    nameLabel.text = @"aaa";
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark UIGestureRecognizerDelegate
- (void) moveSticky:(UIPanGestureRecognizer*)recog
{
    // current tap point on superview
    CGPoint nowPoint;
    
    NSLog(@"panned");
    
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
                NSLog(@"handled %@",NSStringFromCGPoint([recog locationOfTouch:0 inView:self.superview]));
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
