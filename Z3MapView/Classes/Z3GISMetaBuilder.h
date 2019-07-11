//
//  Z3DeviceMetaBuilder.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

- (NSString *)allGISMetaLayerIDs;
@end

NS_ASSUME_NONNULL_END
