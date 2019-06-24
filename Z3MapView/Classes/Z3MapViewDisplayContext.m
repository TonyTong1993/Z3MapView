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
static NSString *context = @"Z3MapViewDisplayContext";
@interface Z3MapViewDisplayContext()
@property (nonatomic,copy) MapViewLoadStatusListener loadStatusListener;
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
    NSArray *layers = [[Z3AGSLayerFactory factory] loadMapLayers];
    NSAssert(layers.count, @"layers count is 0,please check Z3AGSLayerFactory loadMapLayers method");
    [map.operationalLayers addObjectsFromArray:layers];
    [self notifyMapViewLoadStatus];
}

- (void)notifyMapViewLoadStatus {
    AGSMap *map = self.mapView.map;
    [map addObserver:self forKeyPath:@"loadStatus" options:NSKeyValueObservingOptionNew context:&context];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loadStatus"]) {
        NSNumber *value = change[NSKeyValueChangeNewKey];
        AGSLoadStatus status =  [value intValue];
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
    }
}

- (void)dealloc {
    AGSMap *map = self.mapView.map;
    [map removeObserver:self forKeyPath:@"loadStatus"];
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
    NSAssert(envelop.isEmpty, @"envelop must not be empty");
    AGSViewpoint *viewpoint = [[AGSViewpoint alloc] initWithTargetExtent:envelop];
    [self.mapView setViewpoint:viewpoint];
}

- (void)zoomToPoint:(AGSPoint *)point withScale:(double)scale {
    NSAssert(point.isEmpty, @"point must not be empty");
    AGSViewpoint *viewpoint = [[AGSViewpoint alloc] initWithCenter:point scale:scale];
    [self.mapView setViewpoint:viewpoint];
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



@end



