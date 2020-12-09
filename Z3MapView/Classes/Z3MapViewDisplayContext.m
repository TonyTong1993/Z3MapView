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
#import "Z3MobileConfig.h"
#import "Z3User.h"
static NSString *context = @"Z3MapViewDisplayContext";
@interface Z3MapViewDisplayContext()
@property (nonatomic,copy) MapViewLoadStatusListener loadStatusListener;

/**
 显示当前地图中心点的文本
 */
@property (nonatomic,strong) Z3MapViewCenterPropertyView *centerPropertyView;

@property (nonatomic,strong) AGSGraphicsOverlay *addressGraphicsOverlay;
@property (nonatomic,strong) AGSGraphicsOverlay *isueReportSelectDeviceGraphicsOverlay;
@property (nonatomic,strong) AGSGeodatabase *gdb;
@property (nonatomic,assign) BOOL isNeedCheckLayerStatus;
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

- (void)setIsNeedCheckLayerStatus:(BOOL)isCheck{
    _isNeedCheckLayerStatus = isCheck;
}
    
- (void)loadAGSLayers {
    AGSMap *map = self.mapView.map;
    NSAssert(map, @"map must not be null,please set map before to loadAGSLayers");
    Z3AGSLayerFactory *factory = [Z3AGSLayerFactory factory];
    if ([Z3MobileConfig shareConfig].offlineLogin) {
        [self loadLayersByGeodatabase:map];
    }else {
        NSArray *layers = [factory loadMapLayers];
        [map.operationalLayers addObjectsFromArray:layers];
        for (AGSLayer *layer in layers) {
            [layer addObserver:self forKeyPath:@"loadStatus" options:NSKeyValueObservingOptionNew context:&context];
            [layer loadWithCompletion:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"layer : %@ load completion! error:%@",layer.name,[error localizedDescription]);
                    NSLog(@"%@",[error localizedDescription]);
                } else {
                    if(!_isNeedCheckLayerStatus){
                        return;
                    }
                    AGSArcGISMapImageLayer *imageLayer = (AGSArcGISMapImageLayer*)layer;
                    if (![imageLayer respondsToSelector:@selector(mapImageSublayers)]) {
                        return;
                    }
                    [self checkLayerStatus:imageLayer];
                }
            }];
        }
    }
    [self notifyMapViewLoadStatus];
}

//根据用户习惯恢复图层隐藏和显示状态
-(void)checkLayerStatus :(AGSLayer *)layer{
    AGSArcGISMapImageLayer *imageLayer = (AGSArcGISMapImageLayer*)layer;
    NSMutableArray<AGSArcGISMapImageSublayer*> *mapImageSublayers = imageLayer.mapImageSublayers;
    for (AGSArcGISMapImageSublayer *subLayer in mapImageSublayers) {
        NSArray *contents = subLayer.subLayerContents;
        if([contents count] < 1){
            subLayer.visible = [self resetLayerVisibileByLocalState:subLayer];
            continue;
        }
        for (id<AGSLayerContent> subSubLayer in subLayer.subLayerContents) {
            [self checkLayerStatusWithLayerContents:subSubLayer];
        }
    }
}

-(void)checkLayerStatusWithLayerContents:(id<AGSLayerContent>) sublayer {
    NSArray *contents = sublayer.subLayerContents;
    NSLog(@"layer:%@ contents count is: %lu",sublayer.name,contents.count);
    if([contents count] < 1){
        sublayer.visible = [self resetLayerVisibileByLocalState:sublayer];
        return;
    }
    
    for (id<AGSLayerContent> layer in contents) {
        [self checkLayerStatusWithLayerContents:layer];
    }
}

-(BOOL)resetLayerVisibileByLocalState:(id<AGSLayerContent>)layer{
    int nodeSelected = [self getLayerVisibleValueByKey:layer.name];
    if(-1 == nodeSelected){
        return layer.visible;
    } else {
       return nodeSelected;
    }
}

//获取 复选框的勾选状态值
-(int)getLayerVisibleValueByKey:(NSString *)name{
    long userId = [Z3User shareInstance].uid;
    NSString *key = [NSString stringWithFormat:@"%ld_%@_visible",userId,name];
    NSNumber *visibleInt = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    if(nil == visibleInt){
        return -1;
    }
    return visibleInt.intValue;
}

- (void)loadLayersByGeodatabases:(AGSMap *)map {
    Z3AGSLayerFactory *factory = [Z3AGSLayerFactory factory];
    NSArray *geodatabases = [factory offlineGeodatabaseFileNames];
    for (NSString *fileName in geodatabases) {
        [factory loadOfflineGeoDatabaseWithFileName:fileName complicationHandler:^(NSArray *layers, NSError * error) {
            if (error) return;
            [map.operationalLayers addObjectsFromArray:layers];
        }];
    }
}

- (void)loadLayersByGeodatabase:(AGSMap *)map {
    [self loadOfflineMapLayersFromGeoDatabase:^(NSArray * _Nonnull layers) {
        [map.operationalLayers addObjectsFromArray:layers];
    }];
}

- (void)loadOfflineMapLayersFromGeoDatabase:(void (^)(NSArray *layers))complicationHandler {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *geodatabasePath = [documents stringByAppendingPathComponent:@"mwgss.geodatabase"];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:geodatabasePath];
    NSMutableArray *layers = [[NSMutableArray alloc] init];
    if (isExist) {
      NSURL *gdbURL = [[NSURL alloc] initFileURLWithPath:geodatabasePath];
      self.gdb =  [[AGSGeodatabase alloc] initWithFileURL:gdbURL];
         __weak typeof(self) weakSelf = self;
        [self.gdb loadWithCompletion:^(NSError * _Nullable error) {
            if (error) {
              
            }else {
                NSArray *tables = weakSelf.gdb.geodatabaseFeatureTables;
                for (AGSGeodatabaseFeatureTable *table in tables) {
                    AGSFeatureLayer *layer = [[AGSFeatureLayer alloc] initWithFeatureTable:table];
                    [layers addObject:layer];
                }
            }
            complicationHandler([layers copy]);
        }];
    }
}
    
- (void)loadLayersByShapefiles:(AGSMap *)map {
    Z3AGSLayerFactory *factory = [Z3AGSLayerFactory factory];
    NSArray *layers = [factory loadLayersByLocalShapefiles];
    [map.operationalLayers addObjectsFromArray:layers];
}
    
- (void)notifyMapViewLoadStatus {
    AGSMap *map = self.mapView.map;
    [map addObserver:self forKeyPath:@"loadStatus" options:NSKeyValueObservingOptionNew context:&context];
    [self.mapView addObserver:self forKeyPath:@"drawStatus" options:NSKeyValueObservingOptionNew context:&context];
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
            }else if ([object isKindOfClass:[AGSArcGISMapImageLayer class]]) {
                AGSArcGISMapImageLayer *layer = object;
            }else if ([object isKindOfClass:[AGSArcGISVectorTiledLayer class]]) {
                AGSArcGISVectorTiledLayer *layer = object;
                NSLog(@"AGSArcGISVectorTiledLayer load success");
            }
        }
        
    }else if ([keyPath isEqualToString:@"drawStatus"] && object == self.mapView) {
        NSNumber *value = change[NSKeyValueChangeNewKey];
        AGSLoadStatus status =  [value intValue];
        if (status == AGSDrawStatusCompleted) {
            
        }
    }
}
    
- (void)dealloc {
    AGSMap *map = self.mapView.map;
    [map removeObserver:self forKeyPath:@"loadStatus"];
    [self.mapView removeObserver:self forKeyPath:@"visibleArea"];
    [self.mapView removeObserver:self forKeyPath:@"drawStatus"];
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

- (void)showMarkPointWithlocation:(AGSPoint *)location {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildMarkPointGraphicWithPoint:location attributes:nil];
    [self.isueReportSelectDeviceGraphicsOverlay.graphics addObject:graphic];
    if (self.mapView.mapScale > 2000) {
        [self zoomToPoint:location withScale:2000];
    }
}

- (void)removeAddressAnotationView {
    [self.addressGraphicsOverlay.graphics removeAllObjects];
}

- (void)removeIsueReportSelectDeviceView {
    [self.isueReportSelectDeviceGraphicsOverlay.graphics removeAllObjects];
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
    [self setLayerPopOffsetWithHub:hud andFilterView:filterView];
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

- (AGSGraphicsOverlay *)isueReportSelectDeviceGraphicsOverlay {
    if (_isueReportSelectDeviceGraphicsOverlay == nil) {
        for (AGSGraphicsOverlay *overlay in self.mapView.graphicsOverlays) {
            if ([overlay.overlayID isEqualToString:ISUE_REPORT_SELECT_DEVICE_GRAPHICS_OVERLAY_ID]) {
                _isueReportSelectDeviceGraphicsOverlay = overlay;
                break;
            }
        }
        NSAssert(_isueReportSelectDeviceGraphicsOverlay, @"identityGraphicsOverlay not create");
    }
    return _isueReportSelectDeviceGraphicsOverlay;
}

/**
 设置图层控制pop的Y轴偏移量
 */
-(void)setLayerPopOffsetWithHub:(MBProgressHUD *)hud andFilterView:(Z3MapViewLayerFilterView *)filterView{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat rectStatusHeight = rectStatus.size.height;
    CGFloat marignTop = rectStatusHeight + 44;
    CGFloat customeViewHeight = filterView.intrinsicContentSize.height;
    CGFloat yOffSet = marignTop + customeViewHeight * 0.5;
    CGPoint point = CGPointMake(0, - (screenHeight / 2) + yOffSet );
    [hud setOffset:point];
}
    
    
@end



