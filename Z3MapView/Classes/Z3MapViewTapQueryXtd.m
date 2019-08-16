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

/**
 点选位置状态 tapForLocationEnable YES,
 */
@property (nonatomic,assign) BOOL tapForLocationEnable;
@end
@implementation Z3MapViewTapQueryXtd
- (void)display {
    [super display];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapIdentityResultViewControllerDoneNotification:) name:Z3TapIdentityResultViewControllerDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapIdentityResultViewControllerCancelNotification:) name:Z3TapIdentityResultViewControllerCancelNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePickerViewCellTapForSelectDeviceNotification:) name:Z3DevicePickerViewCellTapForSelectDeviceNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePickerViewCellTapForReselectDeviceNotification:) name:Z3DevicePickerViewCellTapForReSelectDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(issueFeedbackViewControllerClearMapViewNotification:) name:Z3IssueFeedbackViewControllerClearMapViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChoiceCellTapForLocationDeviceNotification:) name:Z3LocationChoiceCellTapForLocationDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChoiceCellTapForCancelLocationDeviceNotification:) name:Z3LocationChoiceCellTapForCancelLocationDeviceNotification object:nil];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3TapIdentityResultViewControllerDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3TapIdentityResultViewControllerCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3DevicePickerViewCellTapForSelectDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3IssueFeedbackViewControllerClearMapViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3LocationChoiceCellTapForLocationDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3LocationChoiceCellTapForCancelLocationDeviceNotification object:nil];
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

/*
 *功能描述:点击查询;设备选择;位置选择
 *当处于设备选择和位置选择状态时,不执行父类的clear方法
 */
- (void)identityGraphicFailure {
    if (self.tapForLocationEnable || self.showPickedDevice) {
          [self.mapView.callout dismiss];
    }else {
        [super identityGraphicFailure];
        [self post:Z3MapViewTapQueryXtdIdentityGraphicFailureNotification message:nil];
    }
}

- (void)tapIdentityResultViewControllerDoneNotification:(NSNotification *)notification {
     [self.displayIdentityResultContext dismiss];
    Z3MapViewIdentityResult *result = notification.userInfo[@"message"];
    [self.displayIdentityResultContext updateDevicePickerResult:result];
    [self.identityContext stop];
    _showPickedDevice = YES;
}

- (void)devicePickerViewCellTapForSelectDeviceNotification:(NSNotification *)notification  {
    [self.displayIdentityResultContext dismiss];
    [self.identityContext resume];
    [self.identityContext setIdentityExcludePipeline:YES];
    Z3MapViewIdentityResult *result = notification.userInfo[@"message"];
    if (result) {
         [self.displayIdentityResultContext updateIdentityResults:@[result] showPopup:NO];
    }
    _tapForLocationEnable = NO;
}

- (void)devicePickerViewCellTapForReselectDeviceNotification:(NSNotification *)notification  {
    Z3MapViewIdentityResult *result = notification.userInfo[@"message"];
    if (result) {
        [self.displayIdentityResultContext updateIdentityResults:@[result] showPopup:NO];
    }
    
}

- (void)tapIdentityResultViewControllerCancelNotification:(NSNotification *)notification {
    [self.displayIdentityResultContext dismiss];
}

- (void)issueFeedbackViewControllerClearMapViewNotification:(NSNotification *)notification {
     [self.displayIdentityResultContext dismiss];
    _showPickedDevice = NO;
    [self.identityContext setIdentityExcludePipeline:NO];
}

- (void)locationChoiceCellTapForLocationDeviceNotification:(NSNotification *)notification {
     [self.identityContext stop];
    if (!_showPickedDevice) {
         [self.displayIdentityResultContext dismiss];
    }
    _tapForLocationEnable = YES;
}

- (void)locationChoiceCellTapForCancelLocationDeviceNotification:(NSNotification *)notification {
    if (!_showPickedDevice) {
        [self.identityContext resume];
    }
    _tapForLocationEnable = NO;
}


@end
