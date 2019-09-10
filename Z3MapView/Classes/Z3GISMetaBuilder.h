//
//  Z3DeviceMetaBuilder.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3FeatureLayer;
@interface Z3GISMetaBuilder : NSObject
+ (instancetype)builder;

/**
 获取设备元数据信息

 @param layerName 父图层名字
 @param layerId 设备图层ID
 @return 元数据
 */
- (NSDictionary *)buildDeviceMetaWithTargetLayerName:(NSString *)layerName
                                       targetLayerId:(NSInteger)layerId;

/**
 获取设备元数据信息

 @param layerName 父图层名字
 @param layerId 设备图层ID
 @return 设备属性
 */
- (Z3FeatureLayer *)aomen_buildDeviceMetaWithTargetLayerName:(NSString *)layerName targetLayerId:(NSInteger)layerId;


/**
 根据DNO查询layerId

 @param dno dno
 @return layerId
 */
- (NSString *)layerIdWithDNO:(NSString *)dno;

/**
 获取所有图层ID 集合

 @return  获取所有图层ID
 */
- (NSString *)allGISMetaLayerIDs;


/**
 获取非管线点,图层ID

 @return 图层ID集合字符串
 */
- (NSString *)allExcludePipelineLayerIDs;

/**
 管网图层ID

 @return 图层ID
 */
- (NSString *)pipeLayerID;

/**
 管网图层ID
 
 @return 阀门图层
 */
- (NSInteger )valveLayerID;


/**
 具有关断特性的管点

 @return 图层IDs eg: @"1,2,3"
 */
- (NSString *)closeableValveLayerIDs;


/**
 创建查询条件

 @return 查询条件集合
 */
- (NSArray *)buildFeatureQueryConditions;

/**
 GIS错误上报的图层ID

 @return layerID
 */
- (NSInteger )gisErrorReportLayerID;


/**
 net字段数据不能为空的所有管网元数据信息

 @return 管网元数据信息
 */
- (NSArray *)metaInfosWithNetNotEmpty;


/**
 查询所有管线

 @param code 管网编号
 @return featureLayers
 */
- (NSArray *)pipeLinesWithCode:(NSString *)code;

/**
 查询所有设备点信息

 @param code 管网编号
 @return featureLayers
 */
- (NSArray *)devicesWithCode:(NSString *)code;


/**
 获取设备所有图层IDs

 @return IDs
 */
- (NSString *)deviceLayerIds;

@end

NS_ASSUME_NONNULL_END
