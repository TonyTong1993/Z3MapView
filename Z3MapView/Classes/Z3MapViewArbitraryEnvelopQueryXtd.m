//
//  Z3MapViewArbitraryEnvelopQueryXtd.m
//  AFNetworking
//
//  Created by 童万华 on 2019/7/4.
//范围查询

#import "Z3MapViewArbitraryEnvelopQueryXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
@implementation Z3MapViewArbitraryEnvelopQueryXtd
- (void)display {
    [super display];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onListenerGeometryDidChange:) name:AGSSketchEditorGeometryDidChangeNotification object:nil];
    [self measure];
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
        //    UIImage *redoImage = [UIImage imageNamed:@"nav_redo"];
        //    UIBarButtonItem *redoItem = [[UIBarButtonItem alloc] initWithImage:redoImage style:UIBarButtonItemStylePlain target:self action:@selector(redo)];
        //    [rightItems addObject:redoItem];
        //    UIImage *undoImage = [UIImage imageNamed:@"nav_undo"];
        //    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithImage:undoImage style:UIBarButtonItemStylePlain target:self action:@selector(undo)];
        //    [rightItems addObject:undoItem];
    self.targetViewController.navigationItem.rightBarButtonItems = rightItems;
}

- (void)measure{
    AGSSketchEditor *sketchEditor = [AGSSketchEditor sketchEditor];
    [self.mapView setSketchEditor:sketchEditor];
    [self.mapView.sketchEditor startWithCreationMode:[self creationMode] editConfiguration:[self sketchEditConfiguration]];
    
}

- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    
}

- (void)clear {
    [self.mapView.sketchEditor clearGeometry];
    [self.mapView.callout dismiss];
}

- (AGSSketchEditConfiguration *)sketchEditConfiguration {
    AGSSketchEditConfiguration *configuration = [[AGSSketchEditConfiguration alloc] init];
    
    return configuration;
}

- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModeFreehandPolygon;
}

- (AGSSketchStyle *)style {
    return nil;
}
@end
