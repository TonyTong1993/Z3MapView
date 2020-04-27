//
//  Z3MapViewQueryResponse.m
//  AMP
//
//  Created by ZZHT on 2019/7/29.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewQueryResponse.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3MobileConfig.h"
#import <ArcGIS/ArcGIS.h>
@implementation Z3MapViewQueryResponse
@synthesize data = _data;
- (void)toModel {
    NSDictionary *data = self.responseJSONObject;
    NSArray *features = data[@"features"];
    NSArray *fields = data[@"fields"];
    NSDictionary *spatialReference = data[@"spatialReference"];
    NSDictionary *fieldAliases = data[@"fieldAliases"];
    [[Z3MobileConfig shareConfig] setFieldAliases:fieldAliases];
    [[Z3MobileConfig shareConfig] setFields:fields];
    [[Z3MobileConfig shareConfig] setSpatialReference:spatialReference];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:features.count];
    [features enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Z3MapViewIdentityResult *result = [Z3MapViewIdentityResult modelWithJSON:obj];
        NSDictionary *json = obj[@"geometry"];
        result.geometry = (AGSGeometry *)[AGSGeometry fromJSON:json error:nil];
        NSDictionary *attributes = obj[@"attributes"];
        [result.attributes addEntriesFromDictionary:attributes];
        [result.attributes setValue:@(result.layerId) forKey:@"layerId"];
        [models addObject:result];
    }];
    
    _data = models;
}




@end
