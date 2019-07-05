//
//  Z3MapViewDisplayIdentityResultContext.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewDisplayIdentityResultContext.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3DisplayIdentityResultView.h"
#import "Z3AGSCalloutViewIPad.h"
#import "Z3GraphicFactory.h"
#import "Z3AGSPopupFactory.h"
#import "Z3MapViewPrivate.h"

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
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView identityResults:(NSArray *)results{
    self = [super init];
    if (self) {
        _mapView = mapView;
        [self updateIdentityResults:results];
    }
    return self;
}

- (void)dealloc {
    [self dismiss];
    [self.mapView.graphicsOverlays removeObject:self.mGraphicsOverlay];
    self.mGraphicsOverlay = nil;
}

- (void)setShowPopup:(BOOL)showPopup {
    _showPopup = showPopup;
}

- (void)buildGraphics {
    for (Z3MapViewIdentityResult *result in self.results) {
        AGSGeometry *geometry = [result toGeometry];
        if ([geometry isKindOfClass:[AGSPoint class]]) {
            AGSGraphic *graphic = [[Z3GraphicFactory factory] buildSimpleMarkGraphicWithPoint:(AGSPoint *)geometry attributes:result.attributes];
            [self.graphics addObject:graphic];
        }else if ([geometry isKindOfClass:[AGSPolyline class]]) {
            AGSGraphic *graphic = [[Z3GraphicFactory factory] buildSimpleLineGraphicWithLine:(AGSPolyline *)geometry attributes:result.attributes];
            [self.graphics addObject:graphic];
        }
    }
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
    if (_results.count) {
        [self buildGraphics];
        [self displayGraphics];
        //默认选中第一个
        AGSGraphic *graphic = [self.graphics firstObject];
        [self setSelectedIdentityGraphic:graphic];
    }
}

- (void)displayGraphics {
    self.mGraphicsOverlay = [self identityGraphicsOverlay];
    [self.mGraphicsOverlay.graphics addObjectsFromArray:self.graphics];
}


- (void)dispalyPopview {
    if (!_showPopup) return;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self dispalyPopviewForIpad];
    }else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self displayPopViewForIphone];
    }
}

- (void)dispalyPopviewForIpad {
    Z3AGSCalloutViewIPad *callout = [Z3AGSCalloutViewIPad calloutView];
    [callout setIdentityAttributes:self.selectedGraphic.attributes];
    [self.mapView.callout setCustomView:callout];
    self.mapView.callout.leaderPositionFlags = AGSCalloutLeaderPositionLeft;
    [self.mapView.callout showCalloutForGraphic:self.selectedGraphic tapLocation:nil animated:YES];
}

- (void)displayPopViewForIphone {
    if (_displayIdentityResultView == nil) {
        [self.mapView addSubview:self.displayIdentityResultView];
        [self updateContraints];
        [self.displayIdentityResultView setDataSource:self.results];
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
         [self dismissPopupView];
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
    [self dismiss];
    _results = results;
    _graphics = [NSMutableArray arrayWithCapacity:_results.count];
    [self display];
}

- (void)setSelectedIdentityGraphic:(AGSGraphic *)graphic {
    if (_selectedGraphic != nil) {
         [_selectedGraphic setSelected:false];
    }
    _selectedGraphic = graphic;
    [graphic setSelected:YES];
    AGSPoint *center = nil;
    if ([graphic.geometry isKindOfClass:[AGSPoint class]]) {
        center = (AGSPoint *)graphic.geometry;
    }else {
        AGSPolyline *line = (AGSPolyline *) graphic.geometry;
        center = [[line.parts partAtIndex:0] startPoint];
    }
    [self.mapView setViewpointCenter:center completion:^(BOOL finished) {
        double scale =  self.mapView.mapScale;
        if (scale > 1000) {
            [self.mapView setViewpointScale:1000 completion:^(BOOL finished) {
                [self dispalyPopview];
            }];
        }else {
            [self dispalyPopview];
        }
    }];
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
