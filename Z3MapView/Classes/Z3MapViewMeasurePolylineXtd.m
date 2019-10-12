//
//  Z3MapViewMeasurePolylineXtd.m
//  AFNetworking
//
//  Created by 童万华 on 2019/6/27.
//

#import "Z3MapViewMeasurePolylineXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import "StringUtil.h"
@implementation Z3MapViewMeasurePolylineXtd

- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModePolyline;
}

- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    AGSPolyline *line = (AGSPolyline *)self.mapView.sketchEditor.geometry;
    double distance = [AGSGeometryEngine geodeticLengthOfGeometry:line lengthUnit:[AGSLinearUnit meters] curveType:AGSGeodeticCurveTypeShapePreserving];
    if (distance > 0.0f) {
        AGSPart *part = [[[line parts] array] lastObject];
        AGSPoint *mapPoint = part.endPoint;
        self.mapView.callout.title = LocalizedString(@"str_measure_length_title");
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithDouble:distance]];
        self.mapView.callout.detail = [NSString stringWithFormat:@"%@%@",newAmount,LocalizedString(@"str_unit_unit_meter")];
        
        [self.mapView.callout setAccessoryButtonHidden:YES];
        [self.mapView.callout showCalloutAt:mapPoint screenOffset:CGPointZero rotateOffsetWithMap:NO animated:YES];
    }
}
@end
