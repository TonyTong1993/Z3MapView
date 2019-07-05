//
//  Z3ViewController.m
//  Z3MapView
//
//  Created by Tony Tony on 05/05/2019.
//  Copyright (c) 2019 Tony Tony. All rights reserved.
//

#import "Z3ViewController.h"
#import <ArcGIS/ArcGIS.h>
#import <Z3Login/Z3MobileConfig.h>
#import <Z3Login/Z3MapConfig.h>
#import <Z3Login/Z3MapConfigRequest.h>
#import <Z3Login/Z3MapConfigResponse.h>
#import "Z3MapViewDisplayContext.h"
#import "Z3MapViewTapQueryXtd.h"
#import "Z3MapViewRectQueryXtd.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Z3GISMetaRequest.h"
#import "Z3GISMetaResponse.h"
#import "Z3GISMeta.h"
#import "Z3MapViewPrivate.h"
#import "Z3MapViewOperationBuilder.h"
#import "Z3MapViewOperation.h"
#import "Z3MapViewSwitchOperationView.h"
#import "Z3BuildSimulatedLocationDataSourceXtd.h"
#import "Z3MapViewDisplayUserLocationContext.h"

@interface Z3ViewController ()<Z3MapViewSwitchOperationViewDelegate>
@property (nonatomic,strong) AGSMapView* mapView;
@property (nonatomic,strong) Z3MapViewDisplayContext *displayContext;
@property (nonatomic,strong) Z3MapViewDisplayUserLocationContext *displayDeviceLocationContext;
@property (nonatomic,strong) Z3MapViewCommonXtd *commonQueryXtd;
@property (nonatomic,strong) Z3MapConfigRequest *request;
@property (nonatomic,strong) Z3GISMetaRequest *metaRequest;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation Z3ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *url = @"http://222.92.12.42:8888/map/mobileConfig/MobileMap.xml";
    __weak typeof(self) weakSelf = self;
    self.request = [[Z3MapConfigRequest alloc] initWithAbsoluteURL:url method:GET parameter:@{} success:^(__kindof Z3BaseResponse * _Nonnull response) {
        if (response.error) {
            //TODO:统一失败处理
        }else {
            [weakSelf loadMapView];
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
         //TODO:统一失败处理
    }];
    [self.request start];
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicatorView setAnimatingWithStateOfTask:self.request.requestTask];
}

- (void)loadMapView {
    [self.view addSubview:self.mapView];
    AGSGraphicsOverlay *overlay = [[AGSGraphicsOverlay alloc] init];
    overlay.overlayID = QUERY_GRAPHICS_OVERLAY_ID;
    [self.mapView.graphicsOverlays addObject:overlay];
    
    AGSGraphicsOverlay *overlay1 = [[AGSGraphicsOverlay alloc] init];
    overlay1.overlayID = IDENTITY_GRAPHICS_OVERLAY_ID;
    [self.mapView.graphicsOverlays addObject:overlay1];
    
    self.displayContext = [[Z3MapViewDisplayContext alloc] initWithAGSMapView:self.mapView];
    __weak typeof(self) weakSelf = self;
    [self.displayContext setMapViewLoadStatusListener:^(NSInteger status) {
        if (status == AGSLoadStatusLoaded) {
            [weakSelf mapViewDidLoad];
        }else if (status == AGSLoadStatusFailedToLoad) {
             //TODO:统一失败处理
        }
    }];
   self.displayDeviceLocationContext = [[Z3MapViewDisplayUserLocationContext alloc] initWithAGSMapView:self.mapView];
    [self.mapView.locationDisplay setLocationChangedHandler:^(AGSLocation * _Nonnull location) {
        
    }];
}

- (void)loadGISMetas {
    NSString *url = @"http://192.168.8.86:7777/ServiceEngine/rest/services/NetServer/szgw/metas";
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"f":@"json",@"sys":@"android"};
    self.metaRequest = [[Z3GISMetaRequest alloc] initWithAbsoluteURL:url method:GET parameter:params success:^(__kindof Z3BaseResponse * _Nonnull response) {
        NSArray *metas = response.data;
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        
    }];
}

- (void)mapViewDidLoad {
//    self.commonQueryXtd = [[Z3MapViewTapQueryXtd alloc] initWithTargetViewController:self mapView:self.mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickedMoreOperation:(UIBarButtonItem *)sender {
    self.commonQueryXtd = [[Z3BuildSimulatedLocationDataSourceXtd alloc] initWithTargetViewController:self mapView:self.mapView];
    __weak typeof(self) weakSelf = self;
    [self.commonQueryXtd setOnComplicationListener:^{
        weakSelf.commonQueryXtd = nil;
    }];
    [self.mapView.locationDisplay setLocationChangedHandler:^(AGSLocation * _Nonnull location) {
        
    }];
    
}

- (void)hidePopupView {
    [self.hud hideAnimated:YES];
}

- (void)operationViewDidSelectedOperation:(Z3MapViewOperation *)operation {
    
}

- (AGSMapView *)mapView {
    if (!_mapView) {
        _mapView = [[AGSMapView alloc] initWithFrame:self.view.frame];
        [_mapView setBackgroundColor:[UIColor whiteColor]];
        _mapView.backgroundGrid.gridLineWidth = 1.0;
        _mapView.backgroundGrid.gridLineColor = [UIColor redColor];
        _mapView.interactionOptions.rotateEnabled = NO;
        AGSMap *map = [[AGSMap alloc] init];
        AGSEnvelope* env = [self initialEnvelop];
        if (env) {
            map.initialViewpoint = [[AGSViewpoint alloc] initWithTargetExtent:env];
        }
        _mapView.map = map;
        UIColor *lightGreen = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
        _mapView.selectionProperties = [[AGSSelectionProperties alloc] initWithColor:lightGreen];
    }
    return _mapView;
}

- (AGSEnvelope *)initialEnvelop {
    Z3MapConfig *config = [Z3MobileConfig shareConfig].mapConfig;
    NSArray *values = [config.initialExtent componentsSeparatedByString:@","];
    if (values.count != 4) {
        return nil;
    }
    double xmin = [values[0] doubleValue];
    double ymin = [values[1] doubleValue];
    double xmax = [values[2] doubleValue];
    double ymax = [values[3] doubleValue];
     AGSSpatialReference *spatialReference = [[AGSSpatialReference alloc] initWithWKID:2347];
     AGSEnvelope* env = [[AGSEnvelope alloc]initWithXMin:xmin yMin:ymin xMax:xmax yMax:ymax spatialReference:spatialReference];
    return env;
}

@end
