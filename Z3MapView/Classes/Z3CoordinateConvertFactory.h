//
//  Z3CoordinateConvertFactory.h
//  OutWork
//
//  Created by ZZHT on 2019/6/3.
//  Copyright © 2019年 ZZHT. All rights reserved.
//坐标转换的工具类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSPoint,AGSSpatialReference,CLLocation,AGSGeometry;
@interface Z3CoordinateConvertFactory : NSObject
+ (instancetype)factory;
//WGS48
- (AGSPoint *)pointWithCLLocation:(CLLocation *)location
                  wkid:(NSUInteger)wkid;
- (AGSPoint *)pointWithCLLocation:(CLLocation *)location
                  spatialRefrence:(AGSSpatialReference *)spatialRefrence;
- (AGSPoint *)pointWithCoordinate2D:(CLLocationCoordinate2D)coordinate
                             wkid:(NSUInteger)wkid;
- (AGSPoint *)pointWithCoordinate2D:(CLLocationCoordinate2D)coordinate
                  spatialRefrence:(AGSSpatialReference *)spatialRefrence;

- (AGSPoint *)pointWithLatitude:(double)latitude
                       longitude:(double)longitude
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


@end

NS_ASSUME_NONNULL_END
