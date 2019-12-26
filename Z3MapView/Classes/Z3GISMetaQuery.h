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
@interface Z3GISMetaQuery : NSObject
+ (instancetype)querier;

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

/// 查询元数据中所有包含管网的图层
- (NSArray *)queryAllContainNetsFeatureCollectionLayer;

    /// 获取目标图层的ID
    /// @param layerName 目标图层名字
- (NSString *)targetLayerIDWithLayerName:(NSString *)layerName;

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
 获取指定js的管网中的管线设备

 @param js 从DataJson/fieldAliases.txt中获取
 @return 管线图层集合
 */
- (NSArray *)pipeLayerIDsWithJS:(NSString *)js;

/**
 管网图层ID
 
 @return 阀门图层
 */
- (NSArray *)valveLayerIDs;


/**
 具有关断特性的管点

 @return 图层IDs eg: @"1,2,3"
 */
- (NSString *)closeableValveLayerIDs;


/**
 创建查询条件

 @return 查询条件集合 sections [管网0,管网1]
 */
- (NSArray *)buildPipeNetQueryConditions;

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

- (NSString *)deviceLayerIdsWithNetName:(NSString *)netName;
/**
 获取书签的图层ID

 @return ID
 */
- (NSString *)bookMarkLayerId;
@end

NS_ASSUME_NONNULL_END
