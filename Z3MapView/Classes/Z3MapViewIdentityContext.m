//
//  Z3MapViewIdentityContext.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/18.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewIdentityContext.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewIdentityRequest.h"
#import "Z3MapViewIdentityResponse.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Z3MapViewDisplayIdentityResultContext.h"
#import "Z3MapViewIdentityParameterBuilder.h"
#import "Z3MapViewPrivate.h"
@interface Z3MapViewIdentityContext()<AGSGeoViewTouchDelegate>
@property (nonatomic,strong) AGSLayer *identityLayer;
@property (nonatomic,strong) Z3MapViewIdentityRequest *identityRequest;
@property (nonatomic,strong) Z3MapViewDisplayIdentityResultContext *displayIdentityResultContext;
@property (nonatomic,assign,getter=isPause) BOOL pause;
@property (nonatomic,copy) NSString *identityURL;
@property (nonatomic,assign,getter=isDisplayPopup) BOOL showPopup;
@end
@implementation Z3MapViewIdentityContext
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView {
    self = [super init];
    if (self) {
        _mapView = mapView;
        _mapView.touchDelegate = self;
        _showPopup = YES;
    }
    return self;
}

- (void)dealloc {
    self.displayIdentityResultContext = nil;
    if ([self.identityRequest isExecuting]) {
        [self.identityRequest.requestTask cancel];
    }
}

- (void)setIdentityURL:(NSString *)url {
    _identityURL = url;
}

- (void)setDisplayPopup:(BOOL)showPopup {
    _showPopup = showPopup;
}

- (void)geoView:(AGSGeoView *)geoView didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    if (self.isPause) {
        __weak typeof(self) weaksSelf = self;
        [self.mapView identifyGraphicsOverlay:[self identityGraphicsOverlay] screenPoint:screenPoint tolerance:2 returnPopupsOnly:NO completion:^(AGSIdentifyGraphicsOverlayResult * _Nonnull identifyResult) {
           AGSGraphic *graphic = [identifyResult.graphics firstObject];
            if (graphic) {
                [weaksSelf.displayIdentityResultContext setSelectedIdentityGraphic:graphic];
            }
        }];
        return;
    };

    AGSGeometry *geometory = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(identityContext:didTapAtScreenPoint:mapPoint:)]) {
       geometory = [self.delegate identityContext:self didTapAtScreenPoint:screenPoint mapPoint:mapPoint];
    }else if (self.delegate && [self.delegate respondsToSelector:@selector(identityContext:didTapAtScreenPoint:mapPoint:userInfo:)]) {
        geometory = [self.delegate identityContext:self didTapAtScreenPoint:screenPoint mapPoint:mapPoint userInfo:nil];
    }
    
    if (geometory != nil) {
        NSDictionary *userInfo = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoForIdentityContext:)]) {
            userInfo = [self.delegate userInfoForIdentityContext:self];
        }
        [self identifyGeometry:geometory userInfo:userInfo];
    }
}


- (void)geoView:(AGSGeoView *)geoView didLongPressAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    if (self.isPause && self.displayIdentityResultContext) {
        __weak typeof(self) weakSelf = self;
        [self.mapView identifyGraphicsOverlay:[self identityGraphicsOverlay] screenPoint:screenPoint tolerance:2 returnPopupsOnly:NO completion:^(AGSIdentifyGraphicsOverlayResult * _Nonnull identifyResult) {
            AGSGraphic *graphic = [identifyResult.graphics firstObject];
            if (graphic == nil) {
                return;
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(identityContext:longTapAtScreenPoint:mapPoint:graphic:)]) {
                [weakSelf.delegate identityContext:weakSelf doubleTapAtScreenPoint:screenPoint mapPoint:mapPoint graphic:graphic];
            }
        }];
    };
}

- (void)setIdentityLayer:(AGSLayer *)layer {
    _identityLayer = layer;
}

- (void)identifyGeometry:(AGSGeometry *)geometry userInfo:(NSDictionary *)userInfo{
    NSAssert(self.identityURL.length, @"identity url must not be nil");
    [self identityFeaturesWithGisServer:self.identityURL geometry:geometry userInfo:userInfo];
}


- (void)identityFeaturesWithGisServer:(NSString *)url
                             geometry:(AGSGeometry *)geometry
                             userInfo:(NSDictionary *)userInfo {
    AGSGeometry *temp = [AGSGeometryEngine bufferGeometry:geometry byDistance:2];
    [self identityFeaturesWithGisServer:url geometry:temp tolerance:2 userInfo:userInfo];
}

- (void)identityFeaturesWithGisServer:(NSString *)url
                             geometry:(AGSGeometry *)geometry
                            tolerance:(double)tolerance
                             userInfo:(NSDictionary *)userInfo {
    NSInteger wkid =  self.mapView.spatialReference.WKID;
    AGSEnvelope *extent = self.mapView.visibleArea.extent;
    NSDictionary *params = [[Z3MapViewIdentityParameterBuilder builder] buildIdentityParameterWithGeometry:geometry wkid:wkid mapExtent:extent tolerance:tolerance userInfo:userInfo];
    __weak typeof(self) weakSelf = self;
    self.identityRequest = [[Z3MapViewIdentityRequest alloc] initWithAbsoluteURL:url method:GET parameter:params success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [weakSelf hidenAccessoryView];
        if ([response.data count] == 0) {
            [self showToast:@"未查询到数据"];
            return;
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(identityContextQuerySuccess:identityResults:)]) {
            [weakSelf.delegate identityContextQuerySuccess:weakSelf identityResults:response.data];
        }
        [self pause];
        if (weakSelf.displayIdentityResultContext == nil) {
             weakSelf.displayIdentityResultContext = [[Z3MapViewDisplayIdentityResultContext alloc] initWithAGSMapView:weakSelf.mapView identityResults:response.data];
            [weakSelf.displayIdentityResultContext setShowPopup:weakSelf.showPopup];
        }else {
            [weakSelf.displayIdentityResultContext updateIdentityResults:response.data];
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf hidenAccessoryView];
             [self showToast:@"未查询到数据"];
        });
       
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(identityContextQueryFailure:)]) {
            [weakSelf.delegate identityContextQueryFailure:weakSelf];
        }
    }];
    
    [self.identityRequest start];
    [self showAccessoryView];
}

- (void)showAccessoryView {
    UIView *view = [self.mapView superview];
    NSAssert(view, @"mapView don`t have superview");
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

//TODO:国际化
- (void)showToast:(NSString *)message {
    UIView *view = [self.mapView superview];
    NSAssert(view, @"mapView don`t have superview");
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud showAnimated:YES];
    
    [hud hideAnimated:YES afterDelay:2.5];
}


- (void)hidenAccessoryView {
    UIView *view = [self.mapView superview];
    NSAssert(view, @"mapView don`t have superview");
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)dissmiss {
    [self.displayIdentityResultContext dismiss];
    [self resume];
}

- (void)pause {
    self.pause = YES;
}

- (void)resume {
    self.pause = false;
}

- (void)stop {
    [self pause];
    self.displayIdentityResultContext = nil;
}

- (AGSGraphicsOverlay *)identityGraphicsOverlay {
    AGSGraphicsOverlay *result = nil;
    for (AGSGraphicsOverlay *overlay in self.mapView.graphicsOverlays) {
        if ([overlay.overlayID isEqualToString:IDENTITY_GRAPHICS_OVERLAY_ID]) {
            result = overlay;
            break;
        }
    }
    NSAssert(result, @"identityGraphicsOverlay not create");
    return result;
}

@end
