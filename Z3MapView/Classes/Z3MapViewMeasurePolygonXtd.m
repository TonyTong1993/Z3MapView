//
//  Z3MapViewMeasurePolygonXtd.m
//  AFNetworking
//
//  Created by 童万华 on 2019/6/27.
//

#import "Z3MapViewMeasurePolygonXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import "StringUtil.h"
@implementation Z3MapViewMeasurePolygonXtd
- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModePolygon;
}

- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    AGSPolygon *geometry = (AGSPolygon *)self.mapView.sketchEditor.geometry;
    double area = [AGSGeometryEngine geodeticAreaOfGeometry:geometry areaUnit:[AGSAreaUnit squareKilometers] curveType:AGSGeodeticCurveTypeShapePreserving];
    if (area > 0.0f) {
        AGSPoint *mapPoint =  [[[geometry parts] array] lastObject].endPoint;
        self.mapView.callout.title = LocalizedString(@"str_map_area");
        self.mapView.callout.detail = [NSString stringWithFormat:@"%.4f%@",area,LocalizedString(@"str_unit_square_kilometer")];
        [self.mapView.callout setAccessoryButtonHidden:YES];
        [self.mapView.callout showCalloutAt:mapPoint screenOffset:CGPointZero rotateOffsetWithMap:NO animated:YES];
    }
}
@end
