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
#import "Z3AGSSymbolFactory.h"
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
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [document stringByAppendingPathComponent:@"simulated_trace.json"];
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (isExists) {
       NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSError * __autoreleasing error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSAssert(false, @"模拟轨迹点读取失败");
        }
       AGSPolyline *polyline = (AGSPolyline *)[AGSPolyline fromJSON:json error:&error];
       AGSSimulatedLocationDataSource *dataSource = [[AGSSimulatedLocationDataSource alloc] init];
       [dataSource setLocationsWithPolyline:polyline];
        [self.mapView.locationDisplay setDataSource:dataSource];
    }
    
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeOff;
    [self.mapView.locationDisplay.dataSource startWithCompletion:nil];
    
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
