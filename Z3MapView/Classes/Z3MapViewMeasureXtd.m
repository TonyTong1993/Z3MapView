//
//  Z3MapViewMeasureXtd.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewMeasureXtd.h"
#import <ArcGIS/ArcGIS.h>
@implementation Z3MapViewMeasureXtd


- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onListenerGeometryDidChange:) name:AGSSketchEditorGeometryDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)measureDistance {
   AGSSketchEditor *sketchEditor = [AGSSketchEditor sketchEditor];
   [self.mapView setSketchEditor:sketchEditor];
    [self.mapView.sketchEditor startWithCreationMode:[self creationMode] editConfiguration:[self sketchEditConfiguration]];
    
}

- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    
}

- (AGSSketchEditConfiguration *)sketchEditConfiguration {
    
    AGSSketchEditConfiguration *configuration = [[AGSSketchEditConfiguration alloc] init];

    return configuration;
}

- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModeRectangle;
}

- (AGSSketchStyle *)style {
    return nil;
}



@end
