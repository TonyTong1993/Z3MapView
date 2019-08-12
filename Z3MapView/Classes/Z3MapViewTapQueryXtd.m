//
//  Z3MapViewTapQueryXtd.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewTapQueryXtd.h"
#import "Z3MapViewPrivate.h"
#import "Z3MapViewIdentityContext.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3GraphicFactory.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapView.h"
@interface Z3MapViewTapQueryXtd()

/**
 当前已有选中的设备,showPickedDevice YES
 */
@property (nonatomic,assign) BOOL showPickedDevice;
@end
@implementation Z3MapViewTapQueryXtd
- (void)display {
    [super display];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapIdentityResultViewControllerDoneNotification:) name:Z3TapIdentityResultViewControllerDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapIdentityResultViewControllerCancelNotification:) name:Z3TapIdentityResultViewControllerCancelNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePickerViewCellTapForSelectDeviceNotification:) name:Z3DevicePickerViewCellTapForSelectDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(issueFeedbackViewControllerClearMapViewNotification:) name:Z3IssueFeedbackViewControllerClearMapViewNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3TapIdentityResultViewControllerDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3TapIdentityResultViewControllerCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3DevicePickerViewCellTapForSelectDeviceNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3IssueFeedbackViewControllerClearMapViewNotification object:nil];
}

- (void)displayGraphicWithGeometry:(AGSPoint *)geometry {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildSimpleMarkGraphicWithPoint:geometry attributes:nil];
    [self.queryGraphicsOverlay.graphics addObject:graphic];
    [graphic setSelected:YES];
}

- (void)dismiss {
    [super dismiss];
    [self dissmissGraphicsForQuery];
}

- (void)dissmissGraphicsForQuery {
    if (self.queryGraphicsOverlay) {
        [self.queryGraphicsOverlay.graphics removeAllObjects];
    }
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    [self displayGraphicWithGeometry:mapPoint];
    return (AGSGeometry *)mapPoint;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context identityResults:(nonnull NSArray *)results {
    [super identityContextQuerySuccess:context identityResults:results];
    [self dissmissGraphicsForQuery];
    [self post:Z3MapViewTapQueryXtdIdentitySuccessNotification message:results];
}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    [self dissmissGraphicsForQuery];
    
}

- (void)identityGraphicFailure {
    if (!_showPickedDevice) {
        [super identityGraphicFailure];
        [self post:Z3MapViewTapQueryXtdIdentityGraphicFailureNotification message:nil];
    }else{
        [self.mapView.callout dismiss];
    }
}

- (void)tapIdentityResultViewControllerDoneNotification:(NSNotification *)notification {
     [self.displayIdentityResultContext dismiss];
    //TODO:将选中设备绘制到查询图层上
    Z3MapViewIdentityResult *result = notification.userInfo[@"message"];
    [self.displayIdentityResultContext updateDevicePickerResult:result];
    [self.identityContext stop];
    _showPickedDevice = YES;
}

- (void)devicePickerViewCellTapForSelectDeviceNotification:(NSNotification *)notification  {
     [self.identityContext resume];
}

- (void)tapIdentityResultViewControllerCancelNotification:(NSNotification *)notification {
    if (!_showPickedDevice) {
         [self.displayIdentityResultContext dismiss];
    }
}

- (void)issueFeedbackViewControllerClearMapViewNotification:(NSNotification *)notification {
     [self.displayIdentityResultContext dismiss];
    _showPickedDevice = NO;
}




@end
