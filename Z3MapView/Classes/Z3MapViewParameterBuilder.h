//
//  Z3MapViewIdentityParameterBuilder.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSGeometry;
@interface Z3MapViewParameterBuilder : NSObject
+ (instancetype)builder;

/**
 构建Identity 查询参数

 @param geometry 几何
 @param wkid 坐标系
 @param mapExtent 当前范围
 @param tolerance 容差
 @param exclude 是否过滤管线
 @param userInfo 用户额外信息
 @return 参数
 */
- (NSDictionary *)buildIdentityParameterWithGeometry:(AGSGeometry *)geometry
                                                wkid:(NSInteger)wkid
                                           mapExtent:(AGSGeometry *)mapExtent
                                           tolerance:(double)tolerance
                                     excludePipeLine:(BOOL)exclude
                                            userInfo:(NSDictionary *)userInfo;

/**
 构建Query 查询参数

 @param geometry 几何
 @param userInfo 用户额外信息
 @return 参数
 */
- (NSDictionary *)buildQueryParameterWithGeometry:(AGSGeometry *)geometry
                                         userInfo:(NSDictionary *)userInfo;

- (NSDictionary *)buildPipeAnalyseParameterWithGeometry:(AGSGeometry * _Nullable)geometry
                                               userInfo:(NSDictionary *)userInfo;


/**
 查询管网设备统计的接口

 @param netName 管网名
 @param layerIds 图层IDs
 @param where 条件
 @return 参数
 */
- (NSDictionary *)buildQueryStatisticNetParameterWithNetName:(NSString *)netName
                                               layerIds:(NSString *)layerIds
                                                  where:(NSString *)where;

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
                                                                   outStatistics:(NSString *)outStatistics;


@end

NS_ASSUME_NONNULL_END
