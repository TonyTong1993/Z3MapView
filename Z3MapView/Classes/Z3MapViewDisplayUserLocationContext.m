//
//  Z3MapViewDisplayUserLocationContext.m
//  OutWork
//
//  Created by ZZHT on 2019/7/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewDisplayUserLocationContext.h"
#import "Z3CovertedLocationDataSource.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import "Z3AGSSymbolFactory.h"
#import "Z3SettingsManager.h"
#import "Z3SimutedLocationFactory.h"
#import "Z3GraphicFactory.h"
#import "MBProgressHUD+Z3.h"
#import "Z3LocationManager.h"
@interface Z3MapViewDisplayUserLocationContext()
@property (nonatomic,assign) BOOL showTrack;
@end
@implementation Z3MapViewDisplayUserLocationContext
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView {
    self = [super init];
    if (self) {
        _mapView = mapView;
        [self showUserLocation];
    }
    return self;
}

- (void)showUserTrack:(BOOL)show {
    _showTrack = show;
}

- (void)showUserLocation {
    [self setLocationDataSource];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeOff;
    self.mapView.locationDisplay.showLocation = YES;
}


- (void)showFailureAlert:(NSString *)status {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:status preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    UIResponder *nextResponder = [self.mapView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]]) {
        nextResponder = [nextResponder nextResponder];
    }
    UIViewController *targetViewController = (UIViewController *)nextResponder;
    [targetViewController presentViewController:alert animated:YES completion:nil];
    
}


- (void)loadUserTrace {
    
}

- (void)setLocationDataSource {
    if ([Z3SettingsManager sharedInstance].locationSimulate) {
        AGSPolyline *polyline = [[Z3SimutedLocationFactory factory] buildSimulatedPolyline];
        AGSSimulatedLocationDataSource *dataSource = [[AGSSimulatedLocationDataSource alloc] init];
        [dataSource setLocationsWithPolyline:polyline];
        [self.mapView.locationDisplay setDataSource:dataSource];
        [dataSource startWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                [MBProgressHUD showError:[error localizedDescription]];
            }
        }];
    }else {
        AGSLocationDisplay *locationDisplay = self.mapView.locationDisplay;
        Z3CovertedLocationDataSource *dataSource = [[Z3CovertedLocationDataSource alloc] init];
        [locationDisplay setDataSource:dataSource];
        [locationDisplay startWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                [MBProgressHUD showError:[error localizedDescription]];
            }
        }];
        
        CLLocation *curLocation = [Z3LocationManager manager].location;
        if (curLocation) {
//            AGSPoint *point = [dataSource locationToAgsPoint:curLocation];
//            [self.mapView setViewpointCenter:point completion:^(BOOL finished) {
//            }];
            [dataSource didLocateWithLocation:curLocation];
        }
        
        Z3AGSSymbolFactory *factory = [Z3AGSSymbolFactory factory];
        locationDisplay.defaultSymbol = [factory buildDefaultSymbol];
        locationDisplay.acquiringSymbol = [factory buildDefaultSymbol];
        locationDisplay.courseSymbol = [factory buildCourseSymbol];
        locationDisplay.headingSymbol = [factory buildHeadingSymbol];
    }
}


- (AGSGraphicsOverlay *)trackGraphicsOverlay {
    AGSGraphicsOverlay *result = nil;
    for (AGSGraphicsOverlay *overlay in self.mapView.graphicsOverlays) {
        if ([overlay.overlayID isEqualToString:TRACK_GRAPHICS_OVERLAY_ID]) {
            result = overlay;
            break;
        }
    }
    NSAssert(result, @"identityGraphicsOverlay not create");
    return result;
}

@end
