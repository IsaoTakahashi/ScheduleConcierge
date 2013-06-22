//
//  MapSearchViewController.m
//  ScheduleConcierge
//
//  Created by 高橋 勲 on 2013/06/22.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "MapSearchViewController.h"
#import "PlaceSearchLogic.h"

@interface MapSearchViewController ()

@end

@implementation MapSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

-(void)initializeWithBookmark:(Bookmark*)bm {
    self.bookmark = bm;
}

-(void)showMapView {
    
    if(![self.bookmark.t_place isEqualToString:@""]) {
        PlaceSearchLogic *psLogic = [[PlaceSearchLogic alloc] initWithSearchWord:self.bookmark.t_place];
        NSDictionary *location = [psLogic searchPlaceURL];
        
        if (location != nil) {
            //TODO:longitude とlatitudeに入れる
            self.bookmark.r_latitude = [[location valueForKey:@"lat"] floatValue];
            self.bookmark.r_longitude = [[location valueForKey:@"lng"] floatValue];
        }
    }
    
    CGFloat latitude = self.bookmark.r_latitude;
    CGFloat longitude = self.bookmark.r_longitude;
    
    if (latitude == 0.0f && longitude == 0.0f) {
        latitude = 33.12345;
        longitude = 123.4567;
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:15];
    CGRect viewRect = self.mapBaseView.frame;
    viewRect.origin = CGPointZero;
    self.gmsMapView = [GMSMapView mapWithFrame:viewRect camera:camera];
    self.gmsMapView.delegate = self;
    self.gmsMapView.myLocationEnabled = YES;
    [self.mapBaseView addSubview:self.gmsMapView];
    
    self.marker = [[GMSMarker alloc] init];
    self.marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    self.marker.title = [NSString stringWithFormat:@"%@?",self.bookmark.t_place];
    self.marker.snippet = @"Result by address search";
    
    self.marker.map = self.gmsMapView;
    
}

#pragma mark -
#pragma mark GMSMapViewDelegate
-(void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.marker.position = coordinate;
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Search"
                                                    message:[NSString stringWithFormat:@"Is here %@?",self.bookmark.t_place]
                                                   delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [alert show];
    
    return YES;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    NSLog(@"Tapped");
}


#pragma mark -
#pragma mark Other Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // NO
            break;
        case 1: // YES
            self.bookmark.r_latitude = self.marker.position.latitude;
            self.bookmark.r_longitude = self.marker.position.longitude;
            [self.delegate selectedLocationOnMap:self.bookmark];
            return;
            break;
        default:
            break;
    }
}

- (IBAction)clickedCancel:(id)sender {
    
    [self.delegate canceledMapView];
}
@end
