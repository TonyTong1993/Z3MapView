//
//  Z3MapPOI.m
//  AMP
//
//  Created by ZZHT on 2019/8/7.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapPOI.h"
#import "Z3MobileConfig.h"
#import <ArcGIS/ArcGIS.h>
@implementation Z3MapPOI
- (NSString *)address {
    return self.attributes[self.titleField];
}

- (AGSGeometry *)toGeometry {
    NSInteger wkid = [Z3MobileConfig shareConfig].wkid;
    AGSSpatialReference *spatialReference = [[AGSSpatialReference alloc] initWithWKID:wkid];
    NSDictionary *spatialReferenceDict = [spatialReference toJSON:nil];
    NSMutableDictionary *mGeometry = [[NSMutableDictionary alloc] initWithDictionary:self.geometry];
    [mGeometry addEntriesFromDictionary:spatialReferenceDict];
    AGSGeometry *geometry = (AGSGeometry *)[AGSGeometry fromJSON:mGeometry error:nil];
    return geometry;
}
@end
