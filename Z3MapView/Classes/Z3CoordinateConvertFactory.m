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
    return [self pointWithCoordinate2D:location.coordinate spatialRefrence:spatialRefrence];
}

- (AGSPoint *)pointWithCoordinate2D:(CLLocationCoordinate2D)coordinate wkid:(NSUInteger)wkid {
    AGSSpatialReference *sp = [[AGSSpatialReference alloc] initWithWKID:wkid];
    return [self pointWithCoordinate2D:coordinate spatialRefrence:sp];
}
- (AGSPoint *)pointWithCoordinate2D:(CLLocationCoordinate2D)coordinate spatialRefrence:(AGSSpatialReference *)spatialRefrence {
    return [self pointWithLatitude:coordinate.latitude longitude:coordinate.longitude patialRefrence:spatialRefrence];
}

- (AGSPoint *)pointWithLatitude:(double)latitude longitude:(double)longitude wkid:(NSUInteger)wkid {
    AGSSpatialReference *sp = [[AGSSpatialReference alloc] initWithWKID:wkid];
    return [self pointWithLatitude:latitude longitude:longitude patialRefrence:sp];
}

- (AGSPoint *)pointWithLatitude:(double)latitude longitude:(double)longitude patialRefrence:(AGSSpatialReference *)spatialRefrence {
    CoorTranUtil *coorTrans = [Z3MobileConfig shareConfig].coorTrans;
    CGPoint point = [coorTrans CoorTrans:latitude lon:longitude height:0];
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
        AGSPart *part = [line.parts partAtIndex:0];
        int index = round(part.pointCount /2.0);
        point = [part pointAtIndex:index];
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
                                  complication:(void(^)(AGSPoint *point))complication {
    if ([Z3MobileConfig shareConfig].coorTransToken && location) {
        CLLocationCoordinate2D coordinate = location.coordinate;
        return [self requestConvertWGS48Latitude:coordinate.latitude longitued:coordinate.longitude complication:complication];
    }
    return nil;
}

- (Z3BaseRequest *)requestConvertWGS48Latitude:(double)latitude
                                     longitued:(double)longitude
                                  complication:(void(^)(AGSPoint *point))complication {
    
    if ([Z3MobileConfig shareConfig].coorTransToken) {
        NSString *url = @"http://z3pipe.com:2436/api/v1/coordinate/trans";
        NSDictionary *params = @{
                                 @"x":@(longitude),
                                 @"y":@(latitude),
                                 @"h":@(0),
                                 @"configId":[Z3MobileConfig shareConfig].coorTransToken,
                                 };
        Z3BaseRequest *request = [[Z3BaseRequest alloc] initWithAbsoluteURL:url method:GET parameter:params success:^(__kindof Z3BaseResponse * _Nonnull response) {
            NSInteger code = [response.responseJSONObject[@"code"] intValue];
            if (code == 200) {
                NSDictionary *data = response.responseJSONObject[@"data"];
                double x = [data[@"x"] doubleValue];
                double y = [data[@"y"] doubleValue];
                AGSPoint *point = [self pointWithX:y y:x wkid:[Z3MobileConfig shareConfig].wkid];
                complication(point);
            }else {
//                [MBProgressHUD showError:@"坐标转换失败,请稍后再试!"];
            }
        } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
//            [MBProgressHUD showError:@"坐标转换失败,请稍后再试!"];
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
        NSDictionary *params = @{
                                 @"x":@(point.y),
                                 @"y":@(point.x),
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
//                [MBProgressHUD showError:@"坐标反转失败,请稍后再试!"];
            }
        } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
//            [MBProgressHUD showError:@"坐标反转失败,请稍后再试!"];
        }];
        [request start];
        return request;
    }
    return nil;
}

@end
