//
//  Z3MapViewDisplayUserLocationContext.m
//  OutWork
//
//  Created by ZZHT on 2019/7/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewDisplayUserLocationContext.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
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
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeCompassNavigation;
        //    [[[SimulatePositionProducer alloc] init] loadSimulationLocationJSONWithFileName:@"szsl_trace" complicationHandler:^(NSArray * _Nonnull points) {
        //        AGSSimulatedLocationDataSource *dataSource = [[AGSSimulatedLocationDataSource alloc] init];
        //        [dataSource setLocations:points];
        //        [self.mapView.locationDisplay setDataSource:dataSource];
        //        [dataSource startWithCompletion:^(NSError * _Nullable error) {
        //            if (error) {
        //                [self showFailureAlert:[error localizedDescription]];
        //            }
        //        }];
        //    }];
    
    [self.mapView.locationDisplay startWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            [self showFailureAlert:[error localizedDescription]];
        }
    }];
    
    
}

    //TODO: 国际化
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


- (AGSGraphicsOverlay *)identityGraphicsOverlay {
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
