//
//  Z3MapViewIdentityParameterBuilder.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewParameterBuilder.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3GISMetaQuery.h"
@implementation Z3MapViewParameterBuilder
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
    AGSGeometry *envelop = nil;
    if ([geometry isKindOfClass:[AGSPoint class]]) {
        geometryType = @"esriGeometryPoint";
        envelop = geometry;
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
        NSString *layerIDs = [Z3GISMetaQuery querier].allExcludePipelineLayerIDs;
        mparams[@"layers"] = layerIDs;
    }
    
    if (![mparams.allKeys containsObject:@"layers"]) {
        //获取查询的图层
        NSString *layerIDs = [Z3GISMetaQuery querier].allGISMetaLayerIDs;
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
        geometryType = @"esriGeometryPolygon";
        envelop = (AGSEnvelope *)geometry;
    }
    NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
    if (envelop) {
        NSError * __autoreleasing error = nil;
        NSDictionary *geometryJson= [envelop toJSON:&error];
        NSData *data = [NSJSONSerialization dataWithJSONObject:geometryJson options:NSJSONWritingPrettyPrinted error:&error];
        NSString *geometryJsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (error) {
            NSAssert(false, @"geometry to json string failure");
        }
        mparams[@"geometryType"] = geometryType;
        mparams[@"geometry"] = geometryJsonString;
    }else {
         mparams[@"geometry"] = @"";
    }
    if (userInfo) {
        [mparams addEntriesFromDictionary:userInfo];
    }
    mparams[@"returnGeometry"] = @"true";
    mparams[@"pageSize"] = @"2000";
    return [mparams copy];
}

- (NSDictionary *)buildPipeAnalyseParameterWithGeometry:(AGSPoint *)geometry
                                               userInfo:(NSDictionary *)userInfo{
    NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
    if (geometry) {
        NSString *geometryStr = [NSString stringWithFormat:@"%lf,%lf",geometry.x,geometry.y];
        mparams[@"geometry"] = geometryStr;
    }
    if (userInfo) {
        [mparams addEntriesFromDictionary:userInfo];
    }
    mparams[@"returnGeometry"] = @"true";
    mparams[@"returnNodes"] = @"true";
    mparams[@"returnAllAtt"] = @"true";
    return [mparams copy];
}

/**
 查询管网设备统计的接口
 
 @param netName 管网名
 @param layerIds 图层IDs
 @param where 条件
 @return 参数
 */
- (NSDictionary *)buildQueryStatisticNetParameterWithNetName:(NSString *)netName
                                                    layerIds:(NSString *)layerIds
                                                       where:(NSString *)where {
    NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
    mparams[@"layerIds"] = layerIds;
    mparams[@"where"] = where;
    mparams[@"netName"] = netName;
     return [mparams copy];
}

/*
 access_token=eyJ1c2VyTmFtZSI6ImFkbWluIiwidGltZSI6IjIwMTktMDktMDkgMTg6MDc6MDYifQ==&f=json&where=1=1&groupByFieldsForStatistics=口径&outFields=口径,长度&outStatistics=[{"statisticType":"SUM","onStatisticField":"长度","outStatisticFieldName":"长度"}]&geometry=&returnGeometry=false&timeout=60000
 */

/**
 查询管网管线统计的接口
 
 @param groupByFieldsForStatistics 口径
 @param outFields 口径,长度
 @param outStatistics [{"statisticType":"SUM","onStatisticField":"长度","outStatisticFieldName":"长度"}]
 @return 参数
 */
- (NSDictionary *)buildQueryStatisticPipeParameterWithGroupByFieldsForStatistics:(NSString *)groupByFieldsForStatistics
                                                                       outFields:(NSString *)outFields
                                                                   outStatistics:(NSString *)outStatistics
                                                                           where:(NSString *)where {
    NSMutableDictionary *mparams = [NSMutableDictionary dictionary];
    mparams[@"groupByFieldsForStatistics"] = groupByFieldsForStatistics;
    mparams[@"outFields"] = outFields;
    mparams[@"outStatistics"] = outStatistics;
    mparams[@"geometry"] = @"";
    mparams[@"returnGeometry"] = @"false";
    mparams[@"timeout"] = @(60000);
    mparams[@"where"] = where;
    return [mparams copy];
}

@end
