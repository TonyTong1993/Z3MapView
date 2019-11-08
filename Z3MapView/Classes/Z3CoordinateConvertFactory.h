//
//  Z3CoordinateConvertFactory.h
//  OutWork
//
//  Created by ZZHT on 2019/6/3.
//  Copyright © 2019年 ZZHT. All rights reserved.
//坐标转换的工具类

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN
@class AGSPoint,AGSSpatialReference,CLLocation,AGSGeometry,Z3BaseRequest;
@interface Z3CoordinateConvertFactory : NSObject
+ (instancetype)factory;
//WGS48
- (AGSPoint *)pointWithCLLocation:(CLLocation *)location
                  wkid:(NSUInteger)wkid;

- (CGPoint)cg_pointWithCLLocation:(CLLocation *)location
                             wkid:(NSUInteger)wkid;

- (AGSPoint *)pointWithCLLocation:(CLLocation *)location
                  spatialRefrence:(AGSSpatialReference *)spatialRefrence;
- (AGSPoint *)pointWithCoordinate2D:(CLLocationCoordinate2D)coordinate
                           altitude:(double)altitude
                             wkid:(NSUInteger)wkid;
- (AGSPoint *)pointWithCoordinate2D:(CLLocationCoordinate2D)coordinate
                           altitude:(double)altitude
                  spatialRefrence:(AGSSpatialReference *)spatialRefrence;

- (AGSPoint *)pointWithLatitude:(double)latitude
                       longitude:(double)longitude
                       altitude:(double)altitude
                    wkid:(NSUInteger)wkid;

- (AGSPoint *)pointWithX:(double)x
                       y:(double)y
                    wkid:(NSUInteger)wkid;
- (AGSPoint *)pointWithX:(double)x
                       y:(double)y
                    spatialRefrence:(AGSSpatialReference *)spatialRefrence;

- (CLLocation *)locaitonWithPoint:(AGSPoint *)point;

- (AGSPoint *)labelPointForGeometry:(AGSGeometry *)geometry;

- (CLLocation *)locaitonWithGeometry:(AGSGeometry *)geometry;

- (Z3BaseRequest *)requestConvertWGS48Location:(CLLocation *)location
                                  complication:(void(^)(AGSPoint *point,NSError *error))complication;

- (Z3BaseRequest *)requestConvertWGS48Latitude:(double)latitude
                                     longitued:(double)longitude
                                  complication:(void(^)(AGSPoint *point,NSError *error))complication;

- (Z3BaseRequest *)requestReverseAGSPoint:(AGSPoint *)point
                             complication:(void(^)(CLLocation *location))complication;


@end

NS_ASSUME_NONNULL_END
