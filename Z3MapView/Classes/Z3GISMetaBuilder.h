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
 创建查询条件

 @return 查询条件集合
 */
- (NSArray *)buildFeatureQueryConditions;

/**
 GIS错误上报的图层ID

 @return layerID
 */
- (NSInteger )gisErrorReportLayerID;

@end

NS_ASSUME_NONNULL_END
