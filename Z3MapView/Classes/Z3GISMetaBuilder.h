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

- (NSString *)allGISMetaLayerIDs;

/**
 管网图层ID

 @return 图层ID
 */
- (NSString *)pipeLayerID;


/**
 创建查询条件

 @return 查询条件集合
 */
- (NSArray *)buildFeatureQueryConditions;

@end

NS_ASSUME_NONNULL_END
