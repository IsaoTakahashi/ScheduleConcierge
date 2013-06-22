//
//  MapSearchViewController.h
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Bookmark.h"

@protocol MapSearchViewControllerDelegate <NSObject>

-(void)selectedLocationOnMap:(Bookmark*)bm;
-(void)canceledMapView;

@end

@interface MapSearchViewController : UIViewController<GMSMapViewDelegate,UIAlertViewDelegate>

@property (nonatomic) id<MapSearchViewControllerDelegate> delegate;
@property (nonatomic) Bookmark *bookmark;
@property (nonatomic) GMSMapView *gmsMapView;
@property (nonatomic) GMSMarker *marker;

@property (weak, nonatomic) IBOutlet UIView *mapBaseView;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;

-(void)initializeWithBookmark:(Bookmark*)bm;
-(void)showMapView;

- (IBAction)clickedCancel:(id)sender;

@end
