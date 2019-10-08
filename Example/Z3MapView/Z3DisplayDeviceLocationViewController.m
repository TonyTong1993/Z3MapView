//
//  Z3DisplayDeviceLocationViewController.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/8/31.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3DisplayDeviceLocationViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "MBProgressHUD+Z3.h"
@interface Z3DisplayDeviceLocationViewController ()
@property (nonatomic,strong) AGSMapView* mapView;
@end

@implementation Z3DisplayDeviceLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    [self.view addSubview:self.mapView];
    
    AGSLocationDisplay *locationDisplay = self.mapView.locationDisplay;
    locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeCompassNavigation;
    AGSCLLocationDataSource *locationDataSource = (AGSCLLocationDataSource *)locationDisplay.dataSource;
    CLLocationManager *locationManager = locationDataSource.locationManager;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationDisplay startWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            [MBProgressHUD showError:[error localizedDescription]];
        }else {
            [MBProgressHUD showSuccess:@"定位已经开启"];
        }
    }];
    
}

- (AGSMapView *)mapView {
    if (!_mapView) {
        _mapView = [[AGSMapView alloc] initWithFrame:self.view.frame];
        [_mapView setBackgroundColor:[UIColor whiteColor]];
        _mapView.backgroundGrid.gridLineWidth = 1.0;
        _mapView.backgroundGrid.gridLineColor = [UIColor redColor];
        _mapView.interactionOptions.rotateEnabled = NO;
        AGSBasemap *baseMap = [AGSBasemap imageryBasemap];
        AGSMap *map = [[AGSMap alloc] initWithBasemap:baseMap];
        _mapView.map = map;
        UIColor *lightGreen = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
        _mapView.selectionProperties = [[AGSSelectionProperties alloc] initWithColor:lightGreen];
    }
    return _mapView;
}


@end
