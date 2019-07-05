//
//  Z3BuildSimulatedLocationDataSourceContext.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/7/5.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3BuildSimulatedLocationDataSourceXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
@implementation Z3BuildSimulatedLocationDataSourceXtd

- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModeFreehandPolyline;
}

- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    AGSPolygon *geometry = (AGSPolygon *)self.mapView.sketchEditor.geometry;
    if (geometry.isEmpty) {
        
    }
    
    
}
@end
