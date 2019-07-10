//
//  AGSPointFactory.h
//  OutWork
//
//  Created by ZZHT on 2019/6/3.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
NS_ASSUME_NONNULL_BEGIN
@class AGSPoint,AGSSpatialReference;
@interface AGSPointFactory : NSObject
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
@end

NS_ASSUME_NONNULL_END
