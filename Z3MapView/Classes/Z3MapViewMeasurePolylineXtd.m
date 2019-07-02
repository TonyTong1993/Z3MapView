//
//  Z3MapViewMeasurePolylineXtd.m
//  AFNetworking
//
//  Created by 童万华 on 2019/6/27.
//

#import "Z3MapViewMeasurePolylineXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"

@implementation Z3MapViewMeasurePolylineXtd

- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModePolyline;
}

- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    AGSPolyline *line = (AGSPolyline *)self.mapView.sketchEditor.geometry;
    double distance = [AGSGeometryEngine geodeticLengthOfGeometry:line lengthUnit:[AGSLinearUnit kilometers] curveType:AGSGeodeticCurveTypeShapePreserving];
    if (distance > 0.0f) {
        AGSPart *part = [[[line parts] array] lastObject];
        AGSPoint *mapPoint = part.endPoint;
        self.mapView.callout.title = @"当前位置坐标";
        self.mapView.callout.detail = [NSString stringWithFormat:@"%.2f千米",distance];
        [self.mapView.callout setAccessoryButtonHidden:YES];
        [self.mapView.callout showCalloutAt:mapPoint screenOffset:CGPointZero rotateOffsetWithMap:NO animated:YES];
    }
}
@end
