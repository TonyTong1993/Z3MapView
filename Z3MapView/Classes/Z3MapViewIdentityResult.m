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
#import "Z3MobileConfig.h"
@implementation Z3MapViewIdentityResult

- (AGSGeometry *)toGeometry {
    NSDictionary *geometryJson = self.geometry;
    NSDictionary *spatialReference = geometryJson[@"spatialReference"];
    if (!(spatialReference == nil)) {
        NSMutableDictionary *mgeometry = [NSMutableDictionary dictionaryWithDictionary:geometryJson];
        [mgeometry addEntriesFromDictionary:[Z3MobileConfig shareConfig].spatialReference];
        geometryJson = [mgeometry copy];
    }
    
   NSInteger wkid = [spatialReference[@"spatialReference"] integerValue];
    if (wkid <= 0) {
        NSMutableDictionary *mSpatialReference = [NSMutableDictionary dictionaryWithDictionary:spatialReference];
        [mSpatialReference setValue:@([Z3MobileConfig shareConfig].wkid) forKey:@"wkid"];
        NSMutableDictionary *mgeometry = [NSMutableDictionary dictionaryWithDictionary:geometryJson];
        [mgeometry setValue:[mSpatialReference copy] forKey:@"spatialReference"];
        geometryJson = [mgeometry copy];
    }
    
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

- (NSArray *)displayProperties {
    return @[
             @"79427",
             @"M24198",
             @"2002/11/21 12:21:15",
             ];
}


@end
