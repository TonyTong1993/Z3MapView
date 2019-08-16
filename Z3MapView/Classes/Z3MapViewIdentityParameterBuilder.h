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
@interface Z3MapViewIdentityParameterBuilder : NSObject
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

- (NSDictionary *)buildPipeAnalyseParameterWithGeometry:(AGSGeometry *)geometry
                                               userInfo:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
