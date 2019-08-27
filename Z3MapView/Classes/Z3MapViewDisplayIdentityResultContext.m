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
@property (nonatomic,strong) NSMutableArray *graphics;
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
    [self dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Z3HUDIdentityResultDiplayViewDidChangeSelectIndexNotification object:nil];
}

- (void)setShowPopup:(BOOL)showPopup {
    _showPopup = showPopup;
}

- (void)buildGraphics {
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
            [self.graphics addObject:graphic];
        }else if ([geometry isKindOfClass:[AGSPolyline class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(polylineGraphicForDisplayIdentityResultInMapViewWithGeometry:attributes:)]) {
                graphic =  [_delegate polylineGraphicForDisplayIdentityResultInMapViewWithGeometry:geometry attributes:attributes];
            }else {
                graphic  = [[Z3GraphicFactory factory] buildSimpleLineGraphicWithLine:(AGSPolyline *)geometry attributes:attributes];
                graphic.zIndex = 0;
                [self.graphics addObject:graphic];
            }
           
        }
    }
}

- (void)buildPolygonGraphicWithGeometry:(AGSPolygon *)geometry {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildSimplePolygonGraphicWithPolygon:geometry attributes:nil];
     graphic.zIndex = -1;
     [self.graphics addObject:graphic];
     self.mGraphicsOverlay = [self identityGraphicsOverlay];
    [self.mGraphicsOverlay.graphics addObject:graphic];
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
    [self display:YES];
}

- (void)display:(BOOL)showPopup {
    if (_results.count) {
        [self buildGraphics];
        [self displayGraphics];
        //默认选中第一个
        AGSGraphic *graphic = [self.graphics firstObject];
        [self setSelectedIdentityGraphic:graphic showPopup:showPopup];
    }
}

- (void)displayGraphics {
    self.mGraphicsOverlay = [self identityGraphicsOverlay];
    [self.mGraphicsOverlay.graphics addObjectsFromArray:self.graphics];
}

- (void)dispalyPopview {
#warning 限制当属性为空时,不显示popView
    if (_showPopup && (self.selectedGraphic.attributes.allKeys.count)) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [self dispalyPopviewForIpad];
        }else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [self displayPopViewForIphone];
        }
    }
}

- (void)dispalyPopviewForIpad {
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
    AGSPoint *tapLocation = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(tapLocationForDisplayCalloutView)]) {
       tapLocation =  [_delegate tapLocationForDisplayCalloutView];
    }
    [self.mapView.callout showCalloutForGraphic:self.selectedGraphic tapLocation:tapLocation animated:YES];
}

- (void)displayPopViewForIphone {
    if (_displayIdentityResultView == nil) {
        [self.mapView addSubview:self.displayIdentityResultView];
        [self updateContraints];
        [self.displayIdentityResultView setDataSource:self.results];
        if (self.animationConstraintsForDismiss) {
            [self.mapView removeConstraints:self.animationConstraintsForDismiss];
        }
        _animationConstraintsForPresent = [NSMutableArray array];
        [_animationConstraintsForPresent addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_displayIdentityResultView(160)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayIdentityResultView)]];
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
        [self setSelectedIdentityGraphic:self.graphics[index]];
    }
}

- (void)dismiss {
    if (self.mGraphicsOverlay) {
        [self.mGraphicsOverlay.graphics removeAllObjects];
        [self.graphics removeAllObjects];
        [self post:Z3MapViewIdentityContextDeselectIndexNotification message:nil];
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (_displayIdentityResultView) {
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
        [self.displayIdentityResultView removeFromSuperview];
        self.displayIdentityResultView = nil;
    }];
    [self.mapView layoutIfNeeded];

}

- (void)updateIdentityResults:(NSArray *)results {
    [self updateIdentityResults:results showPopup:YES];
}

- (void)updateIdentityResults:(NSArray *)results
                    showPopup:(BOOL)showPopup{
    [self dismiss];
    _results = results;
    _graphics = [NSMutableArray arrayWithCapacity:_results.count];
    [self display:showPopup];
}

- (void)updatePipeAnalyseResult:(Z3MapViewPipeAnaylseResult *)result {
    NSMutableArray *resluts = [[NSMutableArray alloc] initWithArray:result.valves];
    [resluts addObjectsFromArray:result.users];
    [resluts addObjectsFromArray:result.closeLines];
    [resluts addObjectsFromArray:result.closeNodes];
    [self updateIdentityResults:[resluts copy]];
    [self buildPolygonGraphicWithGeometry:result.closearea];
}


- (void)updateDevicePickerResult:(Z3MapViewPipeAnaylseResult *)result {
     [self updateIdentityResults:@[result]];
}

- (void)updateDevicePickerResult:(Z3MapViewPipeAnaylseResult *)result
                       showPopup:(BOOL)showPopup{
    [self updateIdentityResults:@[result] showPopup:showPopup];
}


- (void)setSelectedIdentityGraphic:(AGSGraphic *)graphic {
    [self setSelectedIdentityGraphic:graphic showPopup:YES];
}

- (void)setSelectedIdentityGraphic:(AGSGraphic *)graphic
                         showPopup:(BOOL)showPopup{
    if (_selectedGraphic != nil) {
        [_selectedGraphic setSelected:false];
    }
    _selectedGraphic = graphic;
    if (_selectedGraphic == nil) return;
    [graphic setSelected:YES];
    AGSPoint *center = nil;
    if ([graphic.geometry isKindOfClass:[AGSPoint class]]) {
        center = (AGSPoint *)graphic.geometry;
    }else {
        AGSPolyline *line = (AGSPolyline *) graphic.geometry;
        center = [[line.parts partAtIndex:0] startPoint];
    }
    NSUInteger index = [self.graphics indexOfObject:graphic];
    [self post:Z3MapViewIdentityContextDidChangeSelectIndexNotification message:@(index)];
    [self.mapView setViewpointCenter:center completion:^(BOOL finished) {
        double scale =  self.mapView.mapScale;
        if (scale > 2000) {
            [self.mapView setViewpointScale:2000 completion:^(BOOL finished) {
                if (showPopup) {
                    [self dispalyPopview];
                }
                
            }];
        }else {
            if (showPopup) {
                [self dispalyPopview];
            }
        }
    }];
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
        [self setSelectedIdentityGraphic:graphic];
    }else {
        [self buildGraphics];
        [self displayGraphics];
        AGSGraphic *graphic = self.graphics[indexPath.row];
        [self setSelectedIdentityGraphic:graphic];
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
