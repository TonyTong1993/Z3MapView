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
@interface Z3MapViewPOIDisplayContext ()
@property (nonatomic,strong) AGSGraphicsOverlay *displayPOIGraphicsOverlay;
@property (nonatomic,strong) NSArray *pois;
@property (nonatomic,strong) AGSGraphic *current;
@end
@implementation Z3MapViewPOIDisplayContext
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView {
    self = [super init];
    if (self) {
        _mapView = mapView;
    }
    return self;
}

- (void)showPOIs:(NSArray *)POIs {
    [self dismissPOIs];
    _pois = POIs;
    [self buildGraphics];
}

- (void)buildGraphics {
    NSMutableArray *graphics = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.pois.count; i++) {
        Z3MapPOI *result = self.pois[i];
        AGSGeometry *geometry = [result toGeometry];
        NSString *text = [NSString stringWithFormat:@"%d",(i+1)];
        AGSGraphic *graphic = [[Z3GraphicFactory factory] buildPOIGraphicWithPoint:(AGSPoint *)geometry text:text attributes:result.attributes];
         [graphics addObject:graphic];
    }
    [self.displayPOIGraphicsOverlay.graphics addObjectsFromArray:graphics];
}

- (void)setSelectPOIAtIndexPath:(NSIndexPath *)indexPath {
    AGSGraphic *graphic = self.displayPOIGraphicsOverlay.graphics[indexPath.row];
    if (_current != graphic) {
        [graphic setSelected:YES];
        [_current setSelected:NO];
        _current = graphic;
        [self.mapView setViewpointCenter:(AGSPoint *)_current.geometry completion:^(BOOL finished) {
            
        }];
    }
}

- (void)dismissPOIs {
    [self.displayPOIGraphicsOverlay.graphics removeAllObjects];
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
