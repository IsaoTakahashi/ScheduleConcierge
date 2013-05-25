//
//  DateBarViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/25.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "DateBarViewController.h"
#import "NSDate+Softbuild.h"

#define STICKY_OFFSET_X 130
#define STICKY_OFFSET_Y 15

@interface DateBarViewController ()

@end

@implementation DateBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.stickies = [NSMutableArray new];
        
        [self viewSetting];
        
        [self.CalcButton setType:BButtonTypeInfo];
        //self.CalcButton.titleLabel.text = @"Route";
    }
    return self;
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

- (void)viewSetting {
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
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)setDate:(NSDate*)date {
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"MM/dd"];
    UIColor *dayColor;
    
    switch ([date weekday]) {
        case 1:
            dayColor = [UIColor redColor];
            break;
        case 7:
            dayColor = [UIColor blueColor];
            break;
        default:
            dayColor = [UIColor blackColor];
            break;
    }
    
    NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:[f stringFromDate:date] attributes:@{NSForegroundColorAttributeName : dayColor}];
    NSAttributedString *dayString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)",[date stringShortweekdayEn]] attributes:@{NSForegroundColorAttributeName : dayColor}];
    
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithAttributedString:dateString];
    [labelString appendAttributedString:dayString];
    
    self.DateLabel.attributedText = labelString;
    
}

- (void)sortStickies {
    if (self.stickies.count == 0) return;
    
    [self.stickies sortUsingComparator:^(UIView *obj1,UIView *obj2) {
        if (obj1.center.x < obj2.center.x) {
            return NSOrderedAscending;
        } else if (obj1.center.x > obj2.center.x) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    
    [self sortAnimation];
}

- (void)sortAnimation {
    int stickyCount = self.stickies.count;

    if (stickyCount == 0) return;
    
    UIView *sticky = self.stickies[0];
    CGFloat stickyWidth = sticky.frame.size.width;
    CGSize areaSize = CGSizeMake(self.view.frame.size.width - STICKY_OFFSET_X,
                                 self.view.frame.size.height - STICKY_OFFSET_Y);
    CGFloat bufferWidth = (areaSize.width - (stickyWidth * stickyCount)) / [@(stickyCount+1) floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    int num = 0;
    for (UIView *view in self.stickies) {
        CGPoint newCenter = CGPointZero;
        newCenter.y = STICKY_OFFSET_Y + areaSize.height / 2.0;
        newCenter.x = STICKY_OFFSET_X + bufferWidth + stickyWidth /2.0 + num * (stickyWidth + bufferWidth);
        view.center = newCenter;
        
        num++;
    }
    
    [UIView commitAnimations];
}

-(Boolean)addSticky:(UIStickyView*)sticky {
    
    if([self.stickies containsObject:sticky]) {
        return false;
    }
    
    sticky.frame = [sticky.superview convertRect:sticky.frame toView:self.view];
    
    [self.view addSubview:sticky];
    [self.stickies addObject:sticky];
    
    NSLog(@"%@ is added to %@",sticky.nameLabel.text,self.DateLabel.text);
    return true;
}

-(Boolean)removeSticky:(UIStickyView*)sticky {
    if(![self.stickies containsObject:sticky] || ![self.view isEqual:sticky.superview]) {
        return false;
    }
    
    sticky.frame = [sticky.superview convertRect:sticky.frame toView:self.view.superview];
    [sticky removeFromSuperview];
    [self.view.superview addSubview:sticky];
    
    [self.stickies removeObject:sticky];
    NSLog(@"%@ was removed from %@",sticky.nameLabel.text,self.DateLabel.text);
    NSLog(@"%@ : %@",sticky.nameLabel.text,NSStringFromCGRect(sticky.frame));

    return true;
}

@end