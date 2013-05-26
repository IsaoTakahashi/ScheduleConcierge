//
//  DirectionViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/05/26.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Direction.h"

@interface DirectionViewController : UIViewController {
    Direction *_direction;
}

@property (nonatomic,setter = setDirection:) Direction *direction;

@property (weak, nonatomic) IBOutlet UILabel *requiredTimeLabel;

-(void)setDirectionSetting:(Direction*)dir;

@end
