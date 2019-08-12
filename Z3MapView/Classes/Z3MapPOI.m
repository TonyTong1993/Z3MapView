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
   double x = [self.geometry[@"x"] doubleValue];
   double y = [self.geometry[@"y"] doubleValue];
   NSInteger wkid = [Z3MobileConfig shareConfig].wkid;
   AGSSpatialReference *spatialReference = [[AGSSpatialReference alloc] initWithWKID:wkid];
   return AGSPointMake(x, y, spatialReference);
}
@end
