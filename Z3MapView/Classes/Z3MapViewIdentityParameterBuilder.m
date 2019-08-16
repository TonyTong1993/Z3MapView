//
//  Z3MapViewIdentityParameterBuilder.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewIdentityParameterBuilder.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3GISMetaBuilder.h"
@implementation Z3MapViewIdentityParameterBuilder
+ (instancetype)builder {
    return [[super alloc] init];
}

- (NSDictionary *)buildIdentityParameterWithGeometry:(AGSGeometry *)geometry
                                                wkid:(NSInteger)wkid
                                           mapExtent:(AGSGeometry *)mapExtent
                                           tolerance:(double)tolerance
                                     excludePipeLine:(BOOL)exclude
                                            userInfo:(NSDictionary *)userInfo{
    NSString *geometryType = @"esriGeometryEnvelope";
    AGSEnvelope *envelop = nil;
    if ([geometry isKindOfClass:[AGSPoint class]]) {
        geometryType = @"esriGeometryEnvelope";
        envelop = [geometry extent];
    }else if ([geometry isKindOfClass:[AGSPolyline class]]) {
        geometryType = @"line";
        envelop = [geometry extent];
    }else if ([geometry isKindOfClass:[AGSEnvelope class]]) {
        geometryType = @"esriGeometryEnvelope";
        envelop = (AGSEnvelope *)geometry;
    }else if ([geometry isKindOfClass:[AGSPolygon class]]) {
        geometryType = @"esriGeometryEnvelope";
        envelop = [geometry extent];
    }
    NSError * __autoreleasing error = nil;
    NSDictionary *geometryJson= [envelop toJSON:&error];
    NSData *data = [NSJSONSerialization dataWithJSONObject:geometryJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *geometryJsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *extentJson = [mapExtent toJSON:&error];
    data = [NSJSONSerialization dataWithJSONObject:extentJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *extentJsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (error) {
        NSAssert(false, @"geometry to json string failure");
    }
    NSString *imageDisplay = @"1080,1767,96";
    
    NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
    if (userInfo) {
        [mparams addEntriesFromDictionary:userInfo];
    }
    
    if (exclude) {
        NSString *layerIDs = [Z3GISMetaBuilder builder].allExcludePipelineLayerIDs;
        mparams[@"layers"] = layerIDs;
    }
    
    if (![mparams.allKeys containsObject:@"layers"]) {
        //获取查询的图层
        NSString *layerIDs = [Z3GISMetaBuilder builder].allGISMetaLayerIDs;
        mparams[@"layers"] = layerIDs;
    }
    mparams[@"geometryType"] = geometryType;
    mparams[@"geometry"] = geometryJsonString;
    mparams[@"mapExtent"] = extentJsonString ;
    mparams[@"sr"] = @(wkid);
    mparams[@"tolerance"] = @(tolerance);
    mparams[@"imageDisplay"] = imageDisplay;
    mparams[@"returnGeometry"] = @"true";
    mparams[@"returnZ"] = @(false);
    mparams[@"returnM"] = @(false);
    return [mparams copy];
}

- (NSDictionary *)buildQueryParameterWithGeometry:(AGSGeometry *)geometry
                                            userInfo:(NSDictionary *)userInfo{
    NSString *geometryType = @"esriGeometryEnvelope";
    AGSEnvelope *envelop = nil;
    if ([geometry isKindOfClass:[AGSPoint class]]) {
        geometryType = @"esriGeometryEnvelope";
        envelop = [geometry extent];
    }else if ([geometry isKindOfClass:[AGSPolyline class]]) {
        geometryType = @"line";
        envelop = [geometry extent];
    }else if ([geometry isKindOfClass:[AGSEnvelope class]]) {
        geometryType = @"esriGeometryEnvelope";
        envelop = (AGSEnvelope *)geometry;
    }else if ([geometry isKindOfClass:[AGSPolygon class]]) {
        geometryType = @"esriGeometryEnvelope";
        envelop = [geometry extent];
    }
    NSError * __autoreleasing error = nil;
    NSDictionary *geometryJson= [envelop toJSON:&error];
    NSData *data = [NSJSONSerialization dataWithJSONObject:geometryJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *geometryJsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (error) {
        NSAssert(false, @"geometry to json string failure");
    }
    NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
    if (userInfo) {
        [mparams addEntriesFromDictionary:userInfo];
    }
    
    mparams[@"geometryType"] = geometryType;
    mparams[@"geometry"] = geometryJsonString;
    mparams[@"returnGeometry"] = @"true";
    return [mparams copy];
}

- (NSDictionary *)buildPipeAnalyseParameterWithGeometry:(AGSPoint *)geometry
                                         userInfo:(NSDictionary *)userInfo{
  
    NSString *geometryStr = [NSString stringWithFormat:@"%lf,%lf",geometry.x,geometry.y];
    NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
    if (userInfo) {
        [mparams addEntriesFromDictionary:userInfo];
    }
    mparams[@"geometry"] = geometryStr;
    mparams[@"returnGeometry"] = @"true";
    return [mparams copy];
}
@end
