//
//  AGSPointFactory.m
//  OutWork
//
//  Created by ZZHT on 2019/6/3.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "AGSPointFactory.h"
#import <ArcGIS/AGSSpatialReference.h>
#import <ArcGIS/AGSPoint.h>
#import "CoorTranUtil.h"
#import "Z3MobileConfig.h"
@implementation AGSPointFactory
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
@end
