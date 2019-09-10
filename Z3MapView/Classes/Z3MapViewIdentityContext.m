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
#import "Z3MapViewQueryRequest.h"
#import "Z3MapViewQueryResponse.h"
#import "Z3MapViewPipeAnalyseRequest.h"
#import "Z3MapViewPipeAnalyseResponse.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Z3MapViewParameterBuilder.h"
#import "Z3MapViewPrivate.h"
#import "Z3MapView.h"
#import "Z3MobileConfig.h"
@interface Z3MapViewIdentityContext()<AGSGeoViewTouchDelegate>
@property (nonatomic,strong) AGSLayer *identityLayer;
@property (nonatomic,strong) AGSGraphicsOverlay *identityGraphicsOverlay;
@property (nonatomic,strong) Z3BaseRequest *identityRequest;

@property (nonatomic,assign,getter=isPause) BOOL pause;
@property (nonatomic,copy) NSString *identityURL;
@property (nonatomic,assign,getter=isDisplayPopup) BOOL showPopup;
@property (nonatomic,assign) Z3MapViewIdentityContextMode mode;
@property (nonatomic,assign) BOOL  excludePipeLine;
@end
@implementation Z3MapViewIdentityContext
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView {
    self = [super init];
    if (self) {
        _mapView = mapView;
        _mapView.touchDelegate = self;
        _showPopup = YES;
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(identityResultDiplayViewDidChangeSelectIndexNotification:) name:Z3HUDIdentityResultDiplayViewDidChangeSelectIndexNotification object:nil];
    }
    return self;
}

- (void)dealloc {
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

- (void)setIdentityExcludePipeline:(Boolean)exclude {
    _excludePipeLine = exclude;
    
}

- (void)geoView:(AGSGeoView *)geoView didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    if (self.isPause) {
        __weak typeof(self) weaksSelf = self;
        [self.mapView identifyGraphicsOverlay:[self identityGraphicsOverlay] screenPoint:screenPoint tolerance:12 returnPopupsOnly:NO completion:^(AGSIdentifyGraphicsOverlayResult * _Nonnull identifyResult) {
           AGSGraphic *graphic = [identifyResult.graphics firstObject];
            if (graphic) {
                if (weaksSelf.delegate && [weaksSelf.delegate respondsToSelector:@selector(identityGraphicSuccess:mapPoint:)]) {
                    [weaksSelf.delegate identityGraphicSuccess:graphic mapPoint:mapPoint];
                }
                
            }else {
                if (weaksSelf.delegate && [weaksSelf.delegate respondsToSelector:@selector(identityGraphicFailure)]) {
                    [weaksSelf.delegate identityGraphicFailure];
                }
                
                [self post:Z3MapViewIdentityContextDidTapAtScreenNotification message:mapPoint];
            }
        }];
        return;
    };
//离线
     __weak typeof(self) weakSelf = self;
    if ([Z3MobileConfig shareConfig].offlineLogin) {
        [geoView identifyLayersAtScreenPoint:screenPoint tolerance:22 returnPopupsOnly:NO completion:^(NSArray<AGSIdentifyLayerResult *> * _Nullable identifyResults, NSError * _Nullable error) {
            if (error) {
                DLog(@"error = %@",error);
                return;
            }
            NSMutableArray *results = [[NSMutableArray alloc] init];
            AGSIdentifyLayerResult *layerResult = [identifyResults firstObject];
            if (layerResult) {
                NSArray *geoElements = layerResult.geoElements;
                for (AGSArcGISFeature *feature in geoElements) {
                    [results addObject:feature];
                }
                if (results.count) {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(identityContextQuerySuccess:mapPoint:identityResults:)]) {
                        [weakSelf.delegate identityContextQuerySuccess:weakSelf mapPoint:mapPoint identityResults:results];
                        [weakSelf pause];
                    }
                }
                
            }
        }];
        return;
    }
//在线
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
        
        switch (self.mode) {
            case Z3MapViewIdentityContextModeIdentity:
                [self identifyGeometry:geometory mapPoint:mapPoint userInfo:userInfo];
                break;
                
            default:
                [self queryFeaturesWithGeometry:geometory mapPoint:mapPoint userInfo:userInfo];
                break;
        }
        
    }
}


- (void)setIdentityLayer:(AGSLayer *)layer {
    _identityLayer = layer;
}

- (void)identifyGeometry:(AGSGeometry *)geometry mapPoint:(AGSPoint *)mapPoint userInfo:(NSDictionary *)userInfo{
    NSAssert(self.identityURL.length, @"identity url must not be nil");
    [self identityFeaturesWithGisServer:self.identityURL geometry:geometry mapPoint:mapPoint userInfo:userInfo];
}

- (void)queryFeaturesWithGeometry:(AGSGeometry *)geometry userInfo:(NSDictionary *)userInfo {
    [self queryFeaturesWithGeometry:geometry mapPoint:nil userInfo:userInfo];
}

- (void)queryFeaturesWithGeometry:(AGSGeometry *)geometry mapPoint:(AGSPoint *)mapPoint userInfo:(NSDictionary *)userInfo{
    NSAssert(self.identityURL.length, @"identity url must not be nil");
    [self queryFeaturesWithGisServer:self.identityURL geometry:geometry mapPoint:mapPoint userInfo:userInfo];
}


- (void)identityFeaturesWithGisServer:(NSString *)url
                             geometry:(AGSGeometry *)geometry
                             mapPoint:(AGSPoint *)mapPoint
                             userInfo:(NSDictionary *)userInfo {
    AGSGeometry *temp = [AGSGeometryEngine bufferGeometry:geometry byDistance:1];
    [self identityFeaturesWithGisServer:url geometry:temp mapPoint:mapPoint tolerance:2 userInfo:userInfo];
}

- (void)identityFeaturesWithGisServer:(NSString *)url
                             geometry:(AGSGeometry *)geometry
                             userInfo:(NSDictionary *)userInfo {
    [self identityFeaturesWithGisServer:url geometry:geometry mapPoint:nil userInfo:userInfo];
}

- (void)identityFeaturesWithGisServer:(NSString *)url
                             geometry:(AGSGeometry *)geometry
                             mapPoint:(AGSPoint *)mapPoint
                            tolerance:(double)tolerance
                             userInfo:(NSDictionary *)userInfo {
    NSInteger wkid =  self.mapView.spatialReference.WKID;
    AGSEnvelope *extent = self.mapView.visibleArea.extent;
    NSDictionary *params = [[Z3MapViewParameterBuilder builder] buildIdentityParameterWithGeometry:geometry wkid:wkid mapExtent:extent tolerance:tolerance excludePipeLine:self.excludePipeLine userInfo:userInfo];
    __weak typeof(self) weakSelf = self;
     [self showAccessoryView];
    self.identityRequest = [[Z3MapViewIdentityRequest alloc] initWithAbsoluteURL:url method:GET parameter:params success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [weakSelf handleSuccessResponse:response mapPoint:mapPoint];
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [weakSelf handleFailureResponse:response];
    }];
     [self.identityRequest  start];
}


- (void)queryFeaturesWithGisServer:(NSString *)url
                             geometry:(AGSGeometry *)geometry
                             mapPoint:(AGSPoint *)mapPoint
                             userInfo:(NSDictionary *)userInfo {
    NSDictionary *params = [[Z3MapViewParameterBuilder builder] buildQueryParameterWithGeometry:geometry  userInfo:userInfo];
    __weak typeof(self) weakSelf = self;
    [self showAccessoryView];
    self.identityRequest = [[Z3MapViewQueryRequest alloc] initWithAbsoluteURL:url method:GET parameter:params success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [weakSelf handleSuccessResponse:response mapPoint:mapPoint];
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [weakSelf handleFailureResponse:response];
    }];
    [self.identityRequest  start];
}

- (void)analyseInfluencedAreaWithGisServer:(NSString *)url
                               geometry:(AGSGeometry *)geometry
                               userInfo:(NSDictionary *)userInfo {
    [self pipeAnalyseFeatureWithGisServer:url geometry:geometry mapPoint:nil userInfo:userInfo];
}

- (void)pipeAnalyseFeatureWithGisServer:(NSString *)url
                               geometry:(AGSGeometry *)geometry
                               mapPoint:(AGSPoint *)mapPoint
                               userInfo:(NSDictionary *)userInfo{
    NSDictionary *params = [[Z3MapViewParameterBuilder builder] buildPipeAnalyseParameterWithGeometry:geometry userInfo:userInfo];
    __weak typeof(self) weakSelf = self;
    [self showAccessoryView];
    self.identityRequest = [[Z3MapViewPipeAnalyseRequest alloc] initWithAbsoluteURL:url method:GET parameter:params success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [weakSelf handlePipeAnalyseSuccessResponse:response mapPoint:mapPoint];
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [weakSelf handleFailureResponse:response];
    }];
    [self.identityRequest  start];
}

- (void)handlePipeAnalyseSuccessResponse:(Z3MapViewPipeAnalyseResponse *)response mapPoint:(AGSPoint *)mapPoint {
    [self hidenAccessoryView];
    if (response.errorMsg) {
        [self showToast:response.errorMsg];
        if (_delegate && [_delegate respondsToSelector:@selector(identityContextAnaylseInfluenceFailure:)]) {
            [_delegate identityContextAnaylseInfluenceFailure:self];
        }
    }else {
        if (_delegate && [_delegate respondsToSelector:@selector(identityContextAnaylseInfluenceSuccess:pipeAnaylseResult:)]) {
            [_delegate identityContextAnaylseInfluenceSuccess:self pipeAnaylseResult:response.data];
            [self pause];
        }
    }
}

- (void)handlePipeAnalyseFailureResponse:(Z3BaseResponse *)response mapPoint:(AGSPoint *)mapPoint {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hidenAccessoryView];
        [self showToast:NSLocalizedString(@"query_failure_tips", @"查询失败,请稍后再试")];
    });
    if (_delegate && [_delegate respondsToSelector:@selector(identityContextAnaylseInfluenceFailure:)]) {
        [_delegate identityContextAnaylseInfluenceFailure:self];
    }
}

- (void)handleSuccessResponse:(Z3BaseResponse *)response mapPoint:(AGSPoint *)mapPoint {
    [self hidenAccessoryView];
    if ([response.data count] == 0) {
        [self showToast:NSLocalizedString(@"query_resluts_empty", @"未查询到数据")];
        if (self.delegate && [self.delegate respondsToSelector:@selector(identityContextQueryFailure:)]) {
            [self.delegate identityContextQueryFailure:self];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(identityContextQuerySuccess:mapPoint:identityResults:)]) {
        [self.delegate identityContextQuerySuccess:self mapPoint:mapPoint identityResults:response.data];
    }
    [self pause];

}

- (void)handleFailureResponse:(Z3BaseResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hidenAccessoryView];
        [self showToast:NSLocalizedString(@"query_failure_tips", @"查询失败,请稍后再试")];
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(identityContextQueryFailure:)]) {
        [self.delegate identityContextQueryFailure:self];
    }
    
}

- (void)showAccessoryView {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    NSAssert(view, @"mapView don`t have superview");
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}


- (void)showToast:(NSString *)message {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    NSAssert(view, @"mapView don`t have superview");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1];
}


- (void)hidenAccessoryView {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    NSAssert(view, @"mapView don`t have superview");
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)clear {
    if (![self.identityRequest isExecuting]) {
        [self resume];
    }
}

- (void)dissmiss {
    if ([self.identityRequest isExecuting]) {
        [self.identityRequest.requestTask cancel];
        [self hidenAccessoryView];
        self.identityRequest = nil;
    }
    [self clear];
}

- (void)pause {
    self.pause = YES;
}

- (void)resume {
    self.pause = false;
}

- (void)stop {
    [self pause];
   
}

- (void)post:(NSNotificationName)notificationName message:(id)message {
    if (message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:@{@"message":message}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }
}

- (void)identityResultDiplayViewDidChangeSelectIndexNotification:(NSNotification *)notification {
    [self pause];
}

- (AGSGraphicsOverlay *)identityGraphicsOverlay {
    if (_identityGraphicsOverlay == nil) {
        for (AGSGraphicsOverlay *overlay in self.mapView.graphicsOverlays) {
            if ([overlay.overlayID isEqualToString:IDENTITY_GRAPHICS_OVERLAY_ID]) {
                _identityGraphicsOverlay = overlay;
                break;
            }
        }
        NSAssert(_identityGraphicsOverlay, @"identityGraphicsOverlay not create");
    }
    return _identityGraphicsOverlay;
}

@end
