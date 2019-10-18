//
//  Z3MapViewDisplayIdentityResultContext.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewDisplayIdentityResultContext.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3MapViewPipeAnaylseResult.h"
#import "Z3DisplayIdentityResultView.h"
#import "Z3AGSCalloutViewIPad.h"
#import "Z3GraphicFactory.h"
#import "Z3AGSPopupFactory.h"
#import "Z3MapViewPrivate.h"
#import "Z3MapView.h"
#import <ArcGIS/ArcGIS.h>
@interface Z3MapViewDisplayIdentityResultContext()<Z3DisplayIdentityResultViewDelegate>
@property (nonatomic,copy) NSArray *results;
@property (nonatomic,strong) AGSGraphicsOverlay *mGraphicsOverlay;
@property (nonatomic,strong) Z3DisplayIdentityResultView *displayIdentityResultView;
@property (nonatomic,strong) NSMutableArray *animationConstraintsForPresent;
@property (nonatomic,strong) NSMutableArray *animationConstraintsForDismiss;
@property (nonatomic,assign) BOOL showPopup;
@end
@implementation Z3MapViewDisplayIdentityResultContext
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView {
    self = [super init];
    if (self) {
        _mapView = mapView;
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(identityResultDiplayViewDidChangeSelectIndexNotification:) name:Z3HUDIdentityResultDiplayViewDidChangeSelectIndexNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3HUDIdentityResultDiplayViewDidChangeSelectIndexNotification object:nil];
}

- (void)setShowPopup:(BOOL)showPopup {
    _showPopup = showPopup;
}

- (void)buildGraphics {
    NSMutableArray *graphics = [[NSMutableArray alloc] init];
    for (AGSArcGISFeature *result in self.results) {
        AGSGeometry *geometry = result.geometry;
        NSDictionary *attributes = result.attributes;
        AGSGraphic *graphic;
        if ([geometry isKindOfClass:[AGSPoint class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(pointGraphicForDisplayIdentityResultInMapViewWithGeometry:attributes:)]) {
                graphic =  [_delegate pointGraphicForDisplayIdentityResultInMapViewWithGeometry:geometry attributes:attributes];
            }else {
                graphic  = [[Z3GraphicFactory factory] buildSimpleMarkGraphicWithPoint:(AGSPoint *)geometry attributes:attributes];
            }
            graphic.zIndex = 1;
            [graphics addObject:graphic];
        }else if ([geometry isKindOfClass:[AGSPolyline class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(polylineGraphicForDisplayIdentityResultInMapViewWithGeometry:attributes:)]) {
                graphic =  [_delegate polylineGraphicForDisplayIdentityResultInMapViewWithGeometry:geometry attributes:attributes];
            }else {
                graphic  = [[Z3GraphicFactory factory] buildSimpleLineGraphicWithLine:(AGSPolyline *)geometry attributes:attributes];
                graphic.zIndex = 0;
                [graphics addObject:graphic];
            }
           
        }
    }
    
    [self.graphics addObjectsFromArray:graphics];
}

- (void)buildPolygonGraphicWithGeometry:(AGSPolygon *)geometry {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildSimplePolygonGraphicWithPolygon:geometry attributes:nil];
    graphic.zIndex = -1;
    [self.graphics addObject:graphic];
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

- (void)display {
    [self displayWithMapPoint:nil showPopup:YES];
}

- (void)displayWithMapPoint:(AGSPoint *)mapPoint
                  showPopup:(BOOL)showPopup {
    if (_results.count) {
        [self buildGraphics];
        //默认选中第一个
        AGSGraphic *graphic = [self.graphics firstObject];
        [self setSelectedIdentityGraphic:graphic mapPoint:mapPoint showPopup:showPopup];
    }
}

- (void)dispalyPopviewWithMapPoint:(AGSPoint *)mapPoint {
    if (_showPopup && (self.selectedGraphic.attributes.allKeys.count)) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [self dispalyPopviewForIpadWithMapPoint:mapPoint];
        }else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [self displayPopViewForIphoneWithMapPoint:mapPoint];
        }
    }
}

- (void)dispalyPopviewForIpadWithMapPoint:(AGSPoint *)mapPoint {
    UIView<Z3CalloutViewDelegate> *callout = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(calloutViewForDisplayIdentityResultInMapView)]) {
        callout =  [_delegate calloutViewForDisplayIdentityResultInMapView];
         self.mapView.callout.leaderPositionFlags = AGSCalloutLeaderPositionBottom;
    }else {
        callout = [Z3AGSCalloutViewIPad calloutView];
        self.mapView.callout.leaderPositionFlags = AGSCalloutLeaderPositionLeft;
    }
    NSUInteger index = [self.graphics indexOfObject:self.selectedGraphic];
    AGSArcGISFeature *feature = self.results[index];
    [callout setIdentityResult:feature];
    [self.mapView.callout setCustomView:callout];
    AGSPoint *tapLocation = mapPoint;
    [self.mapView.callout showCalloutForGraphic:self.selectedGraphic tapLocation:tapLocation animated:YES];
}

- (void)displayPopViewForIphoneWithMapPoint:(AGSPoint *)mapPoint {
    if (_displayIdentityResultView == nil) {
        [self.mapView addSubview:self.displayIdentityResultView];
        [self updateContraints];
        [self.displayIdentityResultView setDataSource:self.results];
        if (self.animationConstraintsForDismiss) {
            [self.mapView removeConstraints:self.animationConstraintsForDismiss];
        }
        _animationConstraintsForPresent = [NSMutableArray array];
        [_animationConstraintsForPresent addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_displayIdentityResultView(146)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayIdentityResultView)]];
        [self.mapView addConstraints:_animationConstraintsForPresent];

    }else {
        NSUInteger index = [self.graphics indexOfObject:self.selectedGraphic];
        [self.displayIdentityResultView setSelectItem:index];
    }
    
}

- (void)updateContraints {
    NSMutableArray *resutls = [NSMutableArray array];
    [resutls addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_displayIdentityResultView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayIdentityResultView)]];
    [self.mapView addConstraints:resutls];
}

#pragma mark - Z3DisplayIdentityResultViewDelegate
- (void)displayIdentityViewDidScrollToPageIndex:(NSUInteger)index {
    if (index >= self.graphics.count) {
        NSAssert(false, @"bound is upper");
    }
   BOOL isSame = self.selectedGraphic == self.graphics[index];
    if (!isSame) {
        [self setSelectedIdentityGraphic:self.graphics[index] mapPoint:nil];
    }
}

- (void)dismiss {
    if (self.mGraphicsOverlay) {
        [self.mGraphicsOverlay.graphics removeAllObjects];
        _graphics = nil;
        [self post:Z3MapViewIdentityContextDeselectIndexNotification message:nil];
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (_displayIdentityResultView) {
            [self.mapView.callout dismiss];
            [self dismissPopupView];
        }
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self.mapView.callout dismiss];
    }
}

- (void)dismissPopupView {
    [UIView animateWithDuration:1 animations:^{
        [self.mapView removeConstraints:self.animationConstraintsForPresent];
        self.animationConstraintsForDismiss = [NSMutableArray array];
        NSDictionary *views = @{@"displayIdentityResultView":self.displayIdentityResultView};
        [self.animationConstraintsForDismiss addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[displayIdentityResultView(160)]-(margin)-|" options:0 metrics:@{@"margin":@(-160)} views:views]];
        [self.mapView addConstraints:self.animationConstraintsForDismiss];
    } completion:^(BOOL finished) {
        if (self.displayIdentityResultView) {
            [self.displayIdentityResultView removeFromSuperview];
            self.displayIdentityResultView = nil;
        }
    }];
    [self.mapView layoutIfNeeded];

}

- (void)updateIdentityResults:(NSArray *)results mapPoint:(AGSPoint *)mapPoint {
    [self updateIdentityResults:results mapPoint:mapPoint showPopup:YES];
}

- (void)updateIdentityResults:(NSArray *)results
                     mapPoint:(AGSPoint *)mapPoint
                    showPopup:(BOOL)showPopup{
    [self dismiss];
    _results = results;
    _graphics = [NSMutableArray arrayWithCapacity:_results.count];
    [self displayWithMapPoint:mapPoint showPopup:showPopup];
}

- (void)updatePipeAnalyseResult:(Z3MapViewPipeAnaylseResult *)result mapPoint:(AGSPoint *)mapPoint {
    NSMutableArray *resluts = [[NSMutableArray alloc] initWithArray:result.valves];
    [resluts addObjectsFromArray:result.users];
    [resluts addObjectsFromArray:result.closeLines];
    [resluts addObjectsFromArray:result.closeNodes];
    [self updateIdentityResults:[resluts copy] mapPoint:mapPoint];
    [self buildPolygonGraphicWithGeometry:result.closearea];
}


- (void)updateDevicePickerResult:(Z3MapViewPipeAnaylseResult *)result mapPoint:(AGSPoint *)mapPoint{
     [self updateIdentityResults:@[result] mapPoint:mapPoint];
}

- (void)updateDevicePickerResult:(Z3MapViewPipeAnaylseResult *)result
                        mapPoint:(AGSPoint *)mapPoint
                       showPopup:(BOOL)showPopup{
    [self updateIdentityResults:@[result] mapPoint:mapPoint showPopup:showPopup];
}


- (void)setSelectedIdentityGraphic:(AGSGraphic *)graphic mapPoint:(AGSPoint *)mapPoint {
    [self setSelectedIdentityGraphic:graphic mapPoint:mapPoint showPopup:YES];
}

- (void)setSelectedGraphicAtIndex:(NSUInteger)index
                        showPopup:(BOOL)showPopup {
    AGSGraphic *graphic = self.graphics[index];
    [self setSelectedIdentityGraphic:graphic mapPoint:nil showPopup:showPopup];
}

- (void)setSelectedIdentityGraphic:(AGSGraphic *)graphic
                          mapPoint:(AGSPoint *)mapPoint
                         showPopup:(BOOL)showPopup{
    if (_selectedGraphic != nil) {
        [_selectedGraphic setSelected:false];
    }
    _selectedGraphic = graphic;
    if (_selectedGraphic == nil) return;
    [graphic setSelected:YES];
    AGSGeometry *geometry = (AGSPolyline *) graphic.geometry;
    AGSPoint *center = [self proximityPointToGeometry:geometry tapLocation:mapPoint];
    NSUInteger index = [self.graphics indexOfObject:graphic];
    [self post:Z3MapViewIdentityContextDidChangeSelectIndexNotification message:@(index)];
    [self.mapView setViewpointCenter:center completion:^(BOOL finished) {
        double scale =  self.mapView.mapScale;
        if (scale > 2000) {
            [self.mapView setViewpointScale:2000 completion:^(BOOL finished) {
                if (showPopup) {
                    [self dispalyPopviewWithMapPoint:center];
                }
                
            }];
        }else {
            if (showPopup) {
                [self dispalyPopviewWithMapPoint:center];
            }
        }
    }];
}

- (AGSPoint *)proximityPointToGeometry:(AGSGeometry *)geometry tapLocation:(AGSPoint *)tapLocation {
    switch (geometry.geometryType) {
        case AGSGeometryTypePoint:
            return (AGSPoint *)geometry;
            break;
        case AGSGeometryTypePolyline:
        {
            if (tapLocation) {
                AGSProximityResult *proximityResult  = [AGSGeometryEngine nearestCoordinateInGeometry:geometry toPoint:tapLocation];
                return proximityResult.point;
            }else {
                AGSPolyline *line = (AGSPolyline *) geometry;
                return [[line.parts partAtIndex:0] startPoint];
            }
        }
            break;
        case AGSGeometryTypePolygon:
        {
            AGSPolygon *polygon = (AGSPolygon *) geometry;
            return [AGSGeometryEngine labelPointForPolygon:polygon];
        }
            break;
        case AGSGeometryTypeEnvelope:
        {
            AGSEnvelope *envelope = (AGSEnvelope *) geometry;
            return [envelope center];
        }
            break;
        default:
            NSAssert(false, @"暂不支持的类型");
            break;
    }
    return nil;
}

- (void)post:(NSNotificationName)notificationName message:(id)message {
    if (message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:@{@"message":message}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }
}

- (void)identityResultDiplayViewDidChangeSelectIndexNotification:(NSNotification *)notification {
    NSIndexPath *indexPath = notification.userInfo[@"message"];
    if (self.graphics.count) {
        AGSGraphic *graphic = self.graphics[indexPath.row];
        [self setSelectedIdentityGraphic:graphic mapPoint:nil];
    }else {
        [self buildGraphics];
        AGSGraphic *graphic = self.graphics[indexPath.row];
        [self setSelectedIdentityGraphic:graphic mapPoint:nil];
    }
   
}

- (Z3DisplayIdentityResultView *)displayIdentityResultView {
    if (!_displayIdentityResultView) {
        _displayIdentityResultView = [[Z3DisplayIdentityResultView alloc] init];
        _displayIdentityResultView.delegate = self;
        _displayIdentityResultView.translatesAutoresizingMaskIntoConstraints = NO;
    }

    return _displayIdentityResultView;
}

@end

@implementation Z3MapViewDisplayIdentityResultContext (Z3BookMark)

- (void)showBookMarks:(NSArray *)bookMarks {
    [self.graphics addObjectsFromArray:bookMarks];
}

- (void)addBookMark:(AGSGraphic *)bookMark {
    [self.graphics insertObject:bookMark atIndex:0];
}

- (void)updateBookMark:(AGSGraphic *)bookMark
               atIndex:(NSUInteger)index {
    [self.graphics replaceObjectAtIndex:index withObject:bookMark];
}

- (void)deleteBookMarkAtIndex:(NSUInteger)index {
    [self.graphics removeObjectAtIndex:index];
}

- (NSMutableArray *)graphics {
    self.mGraphicsOverlay = [self identityGraphicsOverlay];
    return  self.mGraphicsOverlay.graphics;
}

@end
