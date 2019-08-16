//
//  Z3MapViewDisplayContext.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/18.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewDisplayContext.h"
#import "Z3AGSLayerFactory.h"
#import <ArcGIS/ArcGIS.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Z3MapViewOperationBuilder.h"
#import "Z3SettingsManager.h"
#import <YYKit/YYKit.h>
#import "Z3MapViewCenterPropertyView.h"
#import "Z3MapView.h"
#import <Masonry/Masonry.h>
#import "Z3GraphicFactory.h"
#import "Z3MapViewPrivate.h"
static NSString *context = @"Z3MapViewDisplayContext";
@interface Z3MapViewDisplayContext()
@property (nonatomic,copy) MapViewLoadStatusListener loadStatusListener;

/**
 显示当前地图中心点的文本
 */
@property (nonatomic,strong) Z3MapViewCenterPropertyView *centerPropertyView;

@property (nonatomic,strong) AGSGraphicsOverlay *addressGraphicsOverlay;
@end
@implementation Z3MapViewDisplayContext

- (instancetype)initWithAGSMapView:(AGSMapView *)mapView {
    self = [super init];
    if (self) {
        _mapView = mapView;
        [self loadAGSLayers];
    }
    return self;
}

- (void)loadAGSLayers {
    AGSMap *map = self.mapView.map;
    NSAssert(map, @"map must not be null,please set map before to loadAGSLayers");
    Z3AGSLayerFactory *factory = [Z3AGSLayerFactory factory];
    NSArray *layers = [factory loadMapLayers];
    if (!layers.count) {
        [factory loadOfflineMapLayersFromGeoDatabase:^(NSArray * _Nonnull layers) {
            [map.operationalLayers addObjectsFromArray:layers];
            for (AGSFeatureLayer *layer in layers) {
                [layer addObserver:self forKeyPath:@"loadStatus" options:NSKeyValueObservingOptionNew context:&context];
            }
            
        }];
    }else {
        [map.operationalLayers addObjectsFromArray:layers];
        for (AGSLayer *layer in layers) {
            [layer addObserver:self forKeyPath:@"loadStatus" options:NSKeyValueObservingOptionNew context:&context];
            [layer loadWithCompletion:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
            }];
        }
        
    }
    
    [self notifyMapViewLoadStatus];
}

- (void)notifyMapViewLoadStatus {
    AGSMap *map = self.mapView.map;
    [map addObserver:self forKeyPath:@"loadStatus" options:NSKeyValueObservingOptionNew context:&context];
    [self.mapView addObserver:self forKeyPath:@"visibleArea" options:NSKeyValueObservingOptionNew context:&context];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loadStatus"] && object == self.mapView.map) {
        NSNumber *value = change[NSKeyValueChangeNewKey];
        AGSLoadStatus status =  [value intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case AGSLoadStatusLoaded:
                    [self setAccessoryViewEndLoadMapLayers];
                    break;
                case AGSLoadStatusFailedToLoad:
                    [self setAccessoryViewEndLoadMapLayers];
                    break;
                case AGSLoadStatusLoading:
                    [self setAccessoryViewStartLoadMapLayers];
                    break;
                default:
                    break;
            }
            if (self.loadStatusListener) {
                self.loadStatusListener(status);
            }
        });
    }else if ([keyPath isEqualToString:@"visibleArea"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCenterPropertyView];
        });
    }else if ([keyPath isEqualToString:@"loadStatus"] && object != self.mapView.map) {
        NSNumber *value = change[NSKeyValueChangeNewKey];
        AGSLoadStatus status =  [value intValue];
        if (status == AGSLoadStatusLoaded) {
            if ([object isKindOfClass:[AGSFeatureLayer class]]) {
                AGSFeatureLayer *layer = object;
                AGSFeatureTable *table = layer.featureTable;
            }else if ([object isKindOfClass:[AGSArcGISMapImageLayer class]]) {
                AGSArcGISMapImageLayer *layer = object;
#warning 澳门管网宝用于区分底图和要素图层的图层名 GWDT MWS SL 代表的是澳门的要素图层
                if ([layer.name isEqualToString:Z3MapViewOnlineFeatureLayerNameKey]) {
                    [[Z3AGSLayerFactory factory] subLayersForOnlineWithAGSArcGISMapImageLayer:layer];
                }
            }else if ([object isKindOfClass:[AGSArcGISVectorTiledLayer class]]) {
                AGSArcGISVectorTiledLayer *layer = object;
                NSLog(@"AGSArcGISVectorTiledLayer load success");
            }
        }
        
    }
}

- (void)dealloc {
    AGSMap *map = self.mapView.map;
    [map removeObserver:self forKeyPath:@"loadStatus"];
    [self.mapView removeObserver:self forKeyPath:@"visibleArea"];
    for (AGSLayer *layer in map.operationalLayers) {
        [layer removeObserver:self forKeyPath:@"loadStatus"];
    }
}

- (void)setMapViewLoadStatusListener:(MapViewLoadStatusListener)listener {
    _loadStatusListener = listener;
}

- (void)setAccessoryViewStartLoadMapLayers {
    UIView *view = [self.mapView superview];
    NSAssert(view, @"mapView don`t have superview");
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

- (void)setAccessoryViewEndLoadMapLayers {
    UIView *view = [self.mapView superview];
    NSAssert(view, @"mapView don`t have superview");
    [MBProgressHUD hideHUDForView:view animated:YES];
    
}
#pragma mark - control Viewpoint

- (void)zoomIn {
    double scale = _mapView.mapScale*0.5;
    [_mapView setViewpointScale:scale completion:nil];
}

- (void)zoomOut {
    double scale = _mapView.mapScale*2;
    [_mapView setViewpointScale:scale completion:nil];
}

- (void)zoomToEnvelope:(AGSEnvelope *)envelop {
    if (envelop) {
        AGSViewpoint *viewpoint = [[AGSViewpoint alloc] initWithTargetExtent:envelop];
        [self.mapView setViewpoint:viewpoint];
    }
}

- (void)zoomToPoint:(AGSPoint *)point withScale:(double)scale {
    NSAssert(!point.isEmpty, @"point must not be empty");
    AGSViewpoint *viewpoint = [[AGSViewpoint alloc] initWithCenter:point scale:scale];
    __weak typeof(self) weakSelf = self;
    [self.mapView setViewpoint:viewpoint completion:^(BOOL finished) {
         NSLog(@"mapScale = %lf",weakSelf.mapView.mapScale);
    }];
}

- (void)zoomToInitialEnvelop {
    AGSMap *map = self.mapView.map;
    AGSViewpoint *viewpoint = map.initialViewpoint;
    if (viewpoint != nil) {
        [self.mapView setViewpoint:viewpoint];
    }else {
        NSAssert(false, @"you must set map#initialViewpoint");
    }
}

- (void)showAddress:(NSString *)address location:(AGSPoint *)location {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildAddressGraphicWithPoint:location attributes:nil];
    [self.addressGraphicsOverlay.graphics addObject:graphic];
    if (self.mapView.mapScale > 2000) {
         [self zoomToPoint:location withScale:2000];
    }
   
}

//- (void)showTaplocationAnotationView:(AGSPoint *)location {
//    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildAddressGraphicWithPoint:location attributes:nil];
//    [self.tapGraphicsOverlay.graphics addObject:graphic];
//    if (self.mapView.mapScale > 2000) {
//        [self zoomToPoint:location withScale:2000];
//    }
//
//}

- (void)removeAddressAnotationView {
     [self.addressGraphicsOverlay.graphics removeAllObjects];
}
#pragma mark - Control PopupView
- (void)showCenterPropertyView {
    if (!_centerPropertyView) {
        _centerPropertyView = [[Z3MapViewCenterPropertyView alloc] init];
        _centerPropertyView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.mapView addSubview:_centerPropertyView];
        [_centerPropertyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapView.mas_left).offset(25);
            make.bottom.mas_equalTo(self.mapView.mas_bottom).offset(-18);
            make.width.mas_equalTo(206);
            make.height.mas_equalTo(18);
        }];
    }
    [self updateCenterPropertyView];
}

- (void)updateCenterPropertyView {
    if (_centerPropertyView) {
        CGPoint centerP = self.mapView.center;
        AGSPoint *center = [self.mapView screenToLocation:centerP];
        [_centerPropertyView updateX:center.x Y:center.y];
        
    }
}

- (void)showLayerFilterPopUpViewWithDataSource:(NSArray *)dataSource delegate:(id<Z3MapViewOperationDelegate>)delegate{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [hud hideAnimated:YES];
    }];
    [hud.backgroundView addGestureRecognizer:tap];
    Z3MapViewLayerFilterView *filterView = [[Z3MapViewLayerFilterView alloc] initWithLayerDataSource:dataSource andDelegate:delegate];
    hud.customView = filterView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
}

- (void)showMapOpertionViewWithDataSource:(NSArray *)dataSource delegate:(id<Z3MapViewOperationDelegate>)delegate{
    Z3MapViewOperationBuilder *builder = [Z3MapViewOperationBuilder builder];
    NSMutableArray *operations = [builder buildOperations];
    if ([Z3SettingsManager sharedInstance].locationSimulate) {
        Z3MapViewOperation *operation = [builder buildSimulatedLocationOpertaion];
        [operations addObject:operation];
    }
    Z3MapOperationView *operationView = [[Z3MapOperationView alloc] initWithOperationItems:operations withDelegate:delegate];
    [operationView.layer setAnchorPoint:CGPointMake(1, 0)];
    CGFloat width = operationView.bounds.size.width;
    CGFloat height = operationView.bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat topHeight = statusBarHeight + 44;
    operationView.frame = CGRectMake(screenW-width, topHeight, width, height);
    
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [maskView removeFromSuperview];
        [operationView removeFromSuperview];
    }];
    [maskView addGestureRecognizer:tap];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.tag = 1001;
    UIViewController *targetViewController = (UIViewController *)[[self.mapView superview] nextResponder];
    UIView *targetView = [targetViewController.navigationController view];
    [targetView addSubview:maskView];
    [targetView addSubview:operationView];
        //设置动画的初始状态
    operationView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn]; //InOut 表示进入和出去时都启动动画
    [UIView setAnimationDuration:0.3f];//动画时间
    operationView.transform = CGAffineTransformIdentity;//先让要显示的view最小直至消失
    [UIView commitAnimations]; //启动动画
}


- (AGSGraphicsOverlay *)addressGraphicsOverlay {
    if (_addressGraphicsOverlay == nil) {
        for (AGSGraphicsOverlay *overlay in self.mapView.graphicsOverlays) {
            if ([overlay.overlayID isEqualToString:TRACK_GRAPHICS_OVERLAY_ID]) {
                _addressGraphicsOverlay = overlay;
                break;
            }
        }
        NSAssert(_addressGraphicsOverlay, @"identityGraphicsOverlay not create");
    }
    return _addressGraphicsOverlay;
}


@end



