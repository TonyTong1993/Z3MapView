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
#import "Z3GraphicFactory.h"
#import "Z3Theme.h"
#import "UIColor+Z3.h"
@interface Z3MapViewMeasurePolygonXtd()

@end
@implementation Z3MapViewMeasurePolygonXtd
- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModePolygon;
}

- (void)dismiss {
    [super dismiss];
    [self.sketchGraphicsOverlay.graphics removeAllObjects];
}



- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    AGSPolygon *geometry = (AGSPolygon *)self.mapView.sketchEditor.geometry;
    double area = [AGSGeometryEngine geodeticAreaOfGeometry:geometry areaUnit:[AGSAreaUnit squareMeters] curveType:AGSGeodeticCurveTypeShapePreserving];
    if (area > 0.0f) {
        [self.sketchGraphicsOverlay.graphics removeAllObjects];
        for (AGSPart* part in geometry.parts){
            for (AGSSegment *segment in part.array) {
                AGSPoint *startPoint = segment.startPoint;
                AGSPoint *endPoint = segment.endPoint;
                double midX = (startPoint.x + endPoint.x) / 2;
                double midY = (startPoint.y + endPoint.y) / 2;
                AGSPoint *midPoint = AGSPointMake(midX, midY, geometry.spatialReference);
                AGSGeodeticDistanceResult *result = [AGSGeometryEngine geodeticDistanceBetweenPoint1:startPoint point2:endPoint distanceUnit:[AGSLinearUnit meters] azimuthUnit:[AGSAngularUnit degrees] curveType:AGSGeodeticCurveTypeGeodesic];
                double distance = [result distance];
                [self drawLengthOfSideWithMidPoint:midPoint length:distance];
                
            }
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *areaStr = [NSString stringWithFormat:@"%.1f", area]; //保留1位小数
        double areaDouble = [areaStr doubleValue];
        NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithDouble: areaDouble]];
        //NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithDouble:area]];
        self.mapView.callout.title = LocalizedString(@"str_map_area");
        self.mapView.callout.detail = [NSString stringWithFormat:@"%@%@",newAmount,LocalizedString(@"str_unit_square_meter")];
        [self.mapView.callout setAccessoryButtonHidden:YES];
        AGSPoint *point = [AGSGeometryEngine labelPointForPolygon:geometry];
        [self.mapView.callout showCalloutAt:point screenOffset:CGPointZero rotateOffsetWithMap:NO animated:YES];
    }
}

- (void)drawLengthOfSideWithMidPoint:(AGSPoint *)mapPoint length:(double)length {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *distanceStr = [NSString stringWithFormat:@"%.1f", length]; //保留1位小数
    double distanceDouble = [distanceStr doubleValue];
    NSString *fDistance = [formatter stringFromNumber:[NSNumber numberWithDouble: distanceDouble]];
    //NSString *fDistance = [formatter stringFromNumber:[NSNumber numberWithDouble:length]];
    NSString *label = [NSString stringWithFormat:@"%@%@",fDistance,LocalizedString(@"str_unit_unit_meter")];
    CGPoint offset = CGPointMake(20, 20);
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildTextGraphicWithPoint:mapPoint text:label textColor:[UIColor colorWithHex:leftNavBarColorHex] fontFamily:[Z3Theme themeFontFamilyName] fontSize:15 offset:offset attributes:@{}];
    [self.sketchGraphicsOverlay.graphics addObject:graphic];
}


@end
