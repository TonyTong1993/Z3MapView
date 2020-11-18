//
//  Z3MapViewMeasureXtd.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewMeasureXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import "Z3AGSSymbolFactory.h"
@interface Z3MapViewMeasureXtd()

@end
@implementation Z3MapViewMeasureXtd

- (void)display {
    [super display];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onListenerGeometryDidChange:) name:AGSSketchEditorGeometryDidChangeNotification object:nil];
    [self measure];
}

- (void)dealloc {
    [self dismiss];
}

- (void)dismiss {
    [super dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AGSSketchEditorGeometryDidChangeNotification object:nil];
    [self clear];
    [self.mapView.sketchEditor stop];
    self.mapView.sketchEditor = nil;
}

- (void)updateNavigationBar {
    [super updateNavigationBar];
    NSMutableArray *rightItems = [NSMutableArray arrayWithCapacity:3];
    UIImage *cleanImage = [UIImage imageNamed:@"nav_clear"];
    UIBarButtonItem *cleanItem = [[UIBarButtonItem alloc] initWithImage:cleanImage style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [rightItems addObject:cleanItem];
    self.targetViewController.navigationItem.rightBarButtonItems = rightItems;
}

- (void)measure{
    AGSSketchEditor *sketchEditor = [AGSSketchEditor sketchEditor];
    [self.mapView setSketchEditor:sketchEditor];
    [sketchEditor startWithCreationMode:[self creationMode] editConfiguration:[self sketchEditConfiguration]];
    AGSSketchStyle *style = [self style];
    if (style) {
        [sketchEditor setStyle:style];
    }
}

- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    
}

- (void)clear {
    [self.mapView.sketchEditor clearGeometry];
    [self.mapView.callout dismiss];
    [self.sketchGraphicsOverlay.graphics removeAllObjects];
}

- (AGSSketchEditConfiguration *)sketchEditConfiguration {
    AGSSketchEditConfiguration *configuration = [[AGSSketchEditConfiguration alloc] init];

    return configuration;
}

- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModePoint;
}

- (AGSSketchStyle *)style {
    AGSSketchStyle *style = [[AGSSketchStyle alloc] init];
    Z3AGSSymbolFactory *factory = [Z3AGSSymbolFactory factory];
    style.vertexSymbol = [factory buildNormalVertexSymbol];
    style.selectedVertexSymbol = [factory buildSelectedVertexSymbol];
    style.selectedMidVertexSymbol = [factory buildSelectedMidVertexSymbol];
    style.midVertexSymbol = [factory buildNormalMidVertexSymbol];
    UIColor *darkRed = [UIColor colorWithRed:219/255.0 green:105/255.0 blue:180/255.0 alpha:0.5];
    style.lineSymbol = [factory buildPolyLineSymbolWithColor:darkRed ];
    return style;
}

@synthesize sketchGraphicsOverlay = _sketchGraphicsOverlay;
- (AGSGraphicsOverlay *)sketchGraphicsOverlay {
    if (!_sketchGraphicsOverlay) {
        NSArray *graphicsOverlays = self.mapView.graphicsOverlays;
        __block AGSGraphicsOverlay *target = nil;
        [graphicsOverlays enumerateObjectsUsingBlock:^(AGSGraphicsOverlay *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.overlayID isEqualToString:SKETCH_GRAPHICS_OVERLAY_ID]) {
                target = obj;
                *stop = YES;
            }
        }];
        NSAssert(target, @"sketchGraphicsOverlay not found");
        _sketchGraphicsOverlay = target;
    }
    return _sketchGraphicsOverlay;
}


@end
