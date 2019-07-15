//
//  Z3MapViewIdentityResult.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewIdentityResult.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3CoordinateConvertFactory.h"
@implementation Z3MapViewIdentityResult

- (AGSGeometry *)toGeometry {
    NSDictionary *geometryJson = self.geometry;
    NSAssert(geometryJson, @"geometry info is null");
    NSError * __autoreleasing error = nil;
    AGSGeometry *geometry = (AGSGeometry *)[AGSGeometry fromJSON:geometryJson error:&error];
    if (error) {
        NSAssert(false, @"conver to AGSGeometry failure");
    }
    return geometry;
}

- (CLLocation *)destination {
   return [[Z3CoordinateConvertFactory factory] locaitonWithGeometry:[self toGeometry]];
}


@end
