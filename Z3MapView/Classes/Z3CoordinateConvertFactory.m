    //
    //  AGSPointFactory.m
    //  OutWork
    //
    //  Created by ZZHT on 2019/6/3.
    //  Copyright © 2019年 ZZHT. All rights reserved.
    //

#import "Z3CoordinateConvertFactory.h"
#import <ArcGIS/ArcGIS.h>
#import "CoorTranUtil.h"
#import "Z3MobileConfig.h"
#import "Z3BaseRequest.h"
#import "Z3BaseResponse.h"

@implementation Z3CoordinateConvertFactory
+ (instancetype)factory {
    return [[super alloc] init];
}

- (AGSPoint *)pointWithX:(double)x y:(double)y wkid:(NSUInteger)wkid {
    AGSSpatialReference *sp = [[AGSSpatialReference alloc] initWithWKID:wkid];
    return [self pointWithX:x y:y spatialRefrence:sp];
}
- (AGSPoint *)pointWithX:(double)x y:(double)y spatialRefrence:(AGSSpatialReference *)spatialRefrence {
    return AGSPointMake(x, y, spatialRefrence);
}

- (AGSPoint *)pointWithCLLocation:(CLLocation *)location wkid:(NSUInteger)wkid {
    AGSSpatialReference *sp = [[AGSSpatialReference alloc] initWithWKID:wkid];
    return [self pointWithCLLocation:location spatialRefrence:sp];
}

- (CGPoint)cg_pointWithCLLocation:(CLLocation *)location wkid:(NSUInteger)wkid {
   AGSPoint *point = [self pointWithCLLocation:location wkid:wkid];
    return CGPointMake(point.x, point.y);
}

- (AGSPoint *)pointWithCLLocation:(CLLocation *)location spatialRefrence:(AGSSpatialReference *)spatialRefrence {
    return [self pointWithCoordinate2D:location.coordinate altitude:location.altitude spatialRefrence:spatialRefrence];
}

- (AGSPoint *)pointWithCoordinate2D:(CLLocationCoordinate2D)coordinate altitude:(double)altitude wkid:(NSUInteger)wkid {
    AGSSpatialReference *sp = [[AGSSpatialReference alloc] initWithWKID:wkid];
    return [self pointWithCoordinate2D:coordinate altitude:altitude spatialRefrence:sp];
}
- (AGSPoint *)pointWithCoordinate2D:(CLLocationCoordinate2D)coordinate
                           altitude:(double)altitude
                    spatialRefrence:(AGSSpatialReference *)spatialRefrence {
    return [self pointWithLatitude:coordinate.latitude longitude:coordinate.longitude altitude:altitude patialRefrence:spatialRefrence];
}

- (AGSPoint *)pointWithLatitude:(double)latitude
                      longitude:(double)longitude
                       altitude:(double)altitude
                           wkid:(NSUInteger)wkid {
    AGSSpatialReference *sp = [[AGSSpatialReference alloc] initWithWKID:wkid];
    return [self pointWithLatitude:latitude longitude:longitude  altitude:altitude patialRefrence:sp];
}

- (AGSPoint *)pointWithLatitude:(double)latitude
                      longitude:(double)longitude
                       altitude:(double)altitude
                 patialRefrence:(AGSSpatialReference *)spatialRefrence {
    if (spatialRefrence.WKID == [AGSSpatialReference WGS84].WKID) {
       return AGSPointMakeWGS84(latitude, longitude);
    }
    CoorTranUtil *coorTrans = [Z3MobileConfig shareConfig].coorTrans;
    CGPoint point = [coorTrans CoorTrans:latitude lon:longitude height:altitude];
    AGSPoint *agsPoint = [self pointWithX:point.x y:point.y spatialRefrence:spatialRefrence];
    return agsPoint;
}

- (CLLocation *)locaitonWithPoint:(AGSPoint *)point {
    CoorTranUtil *coorTran = [Z3MobileConfig shareConfig].coorTrans;
    CGPoint temp = [coorTran CoorTransReverse:point.x Y:point.y];
    return [[CLLocation alloc] initWithLatitude:temp.x longitude:temp.y];
}

- (AGSPoint *)labelPointForGeometry:(AGSGeometry *)geometry {
    AGSPoint *point = nil;
    if ([geometry isKindOfClass:[AGSPoint class]]) {
        point = (AGSPoint *)geometry;
    }else if ([geometry isKindOfClass:[AGSPolyline class]]) {
        AGSPolyline *line = (AGSPolyline *)geometry;
        AGSPartCollection *parts = line.parts;
        NSInteger middle = parts.count / 2;
        AGSPart *part = [line.parts partAtIndex:middle];
        BOOL todd = part.pointCount % 2 == 1;
        if (todd) {
            NSInteger tmiddle = part.pointCount / 2;
            point =  [part pointAtIndex:tmiddle];;
        } else {
            NSInteger tmiddle = part.pointCount / 2;
            AGSPoint *startPoint = [part pointAtIndex:tmiddle-1];
            AGSPoint *endPoint = [part pointAtIndex:tmiddle];
            double x = (startPoint.x + endPoint.x) / 2;
            double y = (startPoint.y + endPoint.y) / 2;
            point =  AGSPointMake(x, y, nil);
        }
    }else if ([geometry isKindOfClass:[AGSPolygon class]]) {
        AGSPolygon *polygon = (AGSPolygon *)geometry;
        point = [AGSGeometryEngine labelPointForPolygon:polygon];
    }
    NSAssert(point, @"point is nil");
    return point;
}

- (CLLocation *)locaitonWithGeometry:(AGSGeometry *)geometry {
    AGSPoint *point = [self labelPointForGeometry:geometry];
    return [self locaitonWithPoint:point];
}

- (Z3BaseRequest *)requestConvertWGS48Location:(CLLocation *)location
                                  complication:(void(^)(AGSPoint *point,NSError *error))complication {
    if ([Z3MobileConfig shareConfig].coorTransToken && location) {
        CLLocationCoordinate2D coordinate = location.coordinate;
        return [self requestConvertWGS48Latitude:coordinate.latitude longitued:coordinate.longitude complication:complication];
    }
    return nil;
}

- (Z3BaseRequest *)requestConvertWGS48Latitude:(double)latitude
                                     longitued:(double)longitude
                                  complication:(void(^)(AGSPoint *point,NSError *error))complication {
    if ([Z3MobileConfig shareConfig].coorTransToken) {
        NSString *url = @"http://z3pipe.com:2436/api/v1/coordinate/trans";
        NSDictionary *params = @{
                                 @"x":@(longitude),
                                 @"y":@(latitude),
                                 @"h":@(0),
                                 @"configId":[Z3MobileConfig shareConfig].coorTransToken,
                                 };
        Z3BaseRequest *request = [[Z3BaseRequest alloc] initWithAbsoluteURL:url method:GET parameter:params success:^(__kindof Z3BaseResponse * _Nonnull response) {
            if (![response.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                return;
            }
            NSInteger code = [response.responseJSONObject[@"code"] intValue];
            if (code == 200) {
                NSDictionary *data = response.responseJSONObject[@"data"];
                double x = [data[@"x"] doubleValue];
                double y = [data[@"y"] doubleValue];
                BOOL reverse = [Z3MobileConfig shareConfig].coorTransReverse;
                double agsX = reverse ? y : x;
                double agsY = reverse ? x : y;
                AGSPoint *point = [self pointWithX:agsX y:agsY wkid:[Z3MobileConfig shareConfig].wkid];
                complication(point,nil);
            }else {
                NSErrorDomain domain = @"com.zzht.error";
                NSError *error = [NSError errorWithDomain:domain code:400 userInfo:@{NSLocalizedDescriptionKey:@"获取坐标失败"}];
                complication(nil,error);
            }
        } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
            NSError *error = response.error;
            if (error == nil) {
                NSErrorDomain domain = @"com.zzht.error";
                error = [NSError errorWithDomain:domain code:400 userInfo:@{NSLocalizedDescriptionKey:@"获取坐标失败"}];
            }
            complication(nil,error);
        }];
        [request start];
        return request;
    }
    return nil;
}

- (Z3BaseRequest *)requestReverseAGSPoint:(AGSPoint *)point
                                  complication:(void(^)(CLLocation *location))complication {
    if ([Z3MobileConfig shareConfig].coorTransToken && point) {
        NSString *url = @"http://z3pipe.com:2436/api/v1/coordinate/transReverse";
        BOOL reverse = [Z3MobileConfig shareConfig].coorTransReverse;
        double agsX = reverse ? point.y : point.x;
        double agsY = reverse ? point.x : point.y;
        NSDictionary *params = @{
                                 @"x":@(agsX),
                                 @"y":@(agsY),
                                 @"h":@(0),
                                 @"configId":[Z3MobileConfig shareConfig].coorTransToken,
                                 };
        Z3BaseRequest *request = [[Z3BaseRequest alloc] initWithAbsoluteURL:url method:GET parameter:params success:^(__kindof Z3BaseResponse * _Nonnull response) {
            NSInteger code = [response.responseJSONObject[@"code"] intValue];
            if (code == 200) {
                NSDictionary *data = response.responseJSONObject[@"data"];
                double x = [data[@"x"] doubleValue];
                double y = [data[@"y"] doubleValue];
               CLLocation *location = [[CLLocation alloc] initWithLatitude:y longitude:x];
                complication(location);
            }else {

            }
        } failure:^(__kindof Z3BaseResponse * _Nonnull response) {

        }];
        [request start];
        return request;
    }
    return nil;
}

@end
