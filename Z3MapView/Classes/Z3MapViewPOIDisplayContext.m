//
//  Z3MapViewPOIDisplayContext.m
//  AMP
//
//  Created by ZZHT on 2019/8/8.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewPOIDisplayContext.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import "Z3MapPOI.h"
#import "Z3GraphicFactory.h"
#import "Z3POICalloutView.h"
#import "Z3CoordinateConvertFactory.h"
@interface Z3MapViewPOIDisplayContext ()<AGSGeoViewTouchDelegate>
@property (nonatomic,strong) AGSGraphicsOverlay *displayPOIGraphicsOverlay;
@property (nonatomic,strong) NSMutableArray *graphics;
@property (nonatomic,strong) AGSGraphic *current;
@end
@implementation Z3MapViewPOIDisplayContext
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView {
    self = [super init];
    if (self) {
        _mapView = mapView;
        _mapView.touchDelegate = self;
        [_mapView.callout setCustomView:[Z3POICalloutView calloutView]];
    }
    return self;
}

- (void)showPOIs:(NSArray *)POIs {
    [self dismissPOIs];
    _pois = POIs;
    [self buildGraphics];
}

- (void)showPOI:(Z3MapPOI *)POI {
    NSArray *pois = @[POI];
    [self showPOIs:pois];
    [self setSelectPOIAtIndex:0];
}


- (void)buildGraphics {
    NSMutableArray *graphics = [[NSMutableArray alloc] init];
    NSMutableArray *totalGraphics = [[NSMutableArray alloc] init];
    Z3CoordinateConvertFactory *factory = [Z3CoordinateConvertFactory factory];
    for (int i = 0; i < self.pois.count; i++) {
        Z3MapPOI *result = self.pois[i];
        AGSGeometry *geometry = [result toGeometry];
        NSString *text = [NSString stringWithFormat:@"%d",(i+1)];
        
        switch (geometry.geometryType) {
            case AGSGeometryTypePoint:
            {
            AGSGraphic *graphic = [[Z3GraphicFactory factory] buildPOIGraphicWithGeometry:geometry text:text attributes:result.attributes];
            [graphics addObject:graphic];
            [totalGraphics addObject:graphic];
            }
                break;
            case AGSGeometryTypePolyline:
            {
            AGSGeometry *labelPoint = [factory labelPointForGeometry:geometry];
            AGSGraphic *graphic = [[Z3GraphicFactory factory] buildPOIGraphicWithGeometry:geometry text:text attributes:result.attributes];
            [totalGraphics addObject:graphic];
           graphic = [[Z3GraphicFactory factory] buildPOIGraphicWithGeometry:labelPoint text:text attributes:result.attributes];
            [graphics addObject:graphic];
            [totalGraphics addObject:graphic];
           
            
            }
                break;
            case AGSGeometryTypePolygon:
            {
            AGSGeometry *polygon = [factory labelPointForGeometry:geometry];
            AGSGraphic *graphic = [[Z3GraphicFactory factory] buildPOIGraphicWithGeometry:geometry text:text attributes:result.attributes];
            [totalGraphics addObject:graphic];
            graphic = [[Z3GraphicFactory factory] buildPOIGraphicWithGeometry:polygon text:text attributes:result.attributes];
            [graphics addObject:graphic];
            [totalGraphics addObject:graphic];
            }
                break;
            default:
                break;
        }
        
    }
    self.graphics = graphics;
    [self.displayPOIGraphicsOverlay.graphics addObjectsFromArray:totalGraphics];
}

- (void)setSelectPOIAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectPOIAtIndex:indexPath.row];
}

- (void)setSelectPOIAtIndex:(NSUInteger)index {
    NSMutableArray *graphics = self.graphics;
    NSUInteger count = graphics.count;
    if (count < index) {
        return;
    }
    AGSGraphic *graphic = graphics[index];
    if (_current != graphic) {
        [graphic setSelected:YES];
        [_current setSelected:NO];
        _current = graphic;
        __weak typeof(self) weakSelf = self;
        Z3CoordinateConvertFactory *factory = [Z3CoordinateConvertFactory factory];
        AGSPoint *labelPoint = [factory labelPointForGeometry:graphic.geometry];
        double scale =  self.mapView.mapScale;
        if (scale > 1000) {
            [self.mapView setViewpointScale:500 completion:^(BOOL finished) {
                [self.mapView setViewpointCenter:labelPoint completion:^(BOOL finished) {
                    if (self.isShowPopup) {
                        [weakSelf.mapView.callout showCalloutForGraphic:graphic tapLocation:nil animated:YES];
                    }
                }];
            }];
        } else {
            [self.mapView setViewpointCenter:labelPoint completion:^(BOOL finished) {
                if (self.isShowPopup) {
                    [weakSelf.mapView.callout showCalloutForGraphic:graphic tapLocation:nil animated:YES];
                }
            }];
        }
    }
}

- (void)dismissPOIs {
    [self.mapView.callout dismiss];
    [self.displayPOIGraphicsOverlay.graphics removeAllObjects];
    [self.graphics removeAllObjects];
}

- (void)geoView:(AGSGeoView *)geoView didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    [geoView identifyGraphicsOverlay:self.displayPOIGraphicsOverlay screenPoint:screenPoint tolerance:12 returnPopupsOnly:NO completion:^(AGSIdentifyGraphicsOverlayResult * _Nonnull identifyResult) {
        AGSGraphic *graphic = [identifyResult.graphics firstObject];
        if (graphic) {
            [self showPoiPopupView:graphic tapLocation:mapPoint];
        }else {
            [geoView.callout dismiss];
            [self.current setSelected:NO];
            self.current = nil;
        }
    }];
}

- (void)showPoiPopupView:(AGSGraphic *)graphic tapLocation:(AGSPoint *)tapLocation{
    if ( _current != graphic) {
        graphic.selected = YES;
        _current.selected = NO;
        _current = graphic;
        __weak typeof(self) weakSelf = self;
        [self.mapView setViewpointCenter:(AGSPoint *)_current.geometry completion:^(BOOL finished) {
            if (weakSelf.isShowPopup) {
                [weakSelf.mapView.callout showCalloutForGraphic:graphic tapLocation:nil animated:YES];
            }
        }];
    }
    
}

- (void)dealloc {
    [self.mapView.callout setCustomView:nil];
}

- (AGSGraphicsOverlay *)displayPOIGraphicsOverlay {
    if (!_displayPOIGraphicsOverlay) {
        for (AGSGraphicsOverlay *overlay in self.mapView.graphicsOverlays) {
            if ([overlay.overlayID isEqualToString:POI_GRAPHICS_OVERLAY_ID]) {
                _displayPOIGraphicsOverlay = overlay;
                break;
            }
        }
        NSAssert(_displayPOIGraphicsOverlay, @"identityGraphicsOverlay not create");
    }
    return _displayPOIGraphicsOverlay;
}
@end
