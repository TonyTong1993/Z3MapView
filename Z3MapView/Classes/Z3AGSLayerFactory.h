//
//  Z3AGSLayerFactory.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/18.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSBasemap,AGSLayer,AGSArcGISMapImageLayer,Z3MapLayer;
@protocol AGSLayerContent;
@interface Z3AGSLayerFactory : NSObject
+ (instancetype)factory;
- (NSArray *)loadMapLayers;
- (AGSLayer *)loadMapLayer:(Z3MapLayer *)mapLayer;
- (AGSBasemap *)localBaseMap;
- (AGSBasemap *)onlineBaseMap;
- (AGSBasemap *)onlineBaseMapWithMapLayer:(Z3MapLayer *)mapLayer;
- (AGSLayer *)localBaseMapLayer;
- (void)loadOfflineMapLayersFromGeoDatabase:(void (^)(NSArray *layers))complicationHandler;
- (void)subLayersForOnlineWithAGSArcGISMapImageLayer:(id<AGSLayerContent>)layer;
- (void)filterSubLayesForOnLineWithAGSArcGISMapImageLayer:(AGSArcGISMapImageLayer *)layer
                                                      ids:(NSArray *)ids
                                                  visible:(BOOL)visible;

- (void)legendsFromAGSArcGISMapImageLayer:(id<AGSLayerContent>)layer
                             complication:(void(^)(Z3MapLayer *layer))complication;
/**
 加载离线数据

 @param fileName 离线geodatabase 文件名
 @param complicationHandler 完成回调
 */
- (void)loadOfflineGeoDatabaseWithFileName:(NSString *)fileName
                       complicationHandler:(void (^)(NSArray * _Nullable layers,  NSError * _Nullable error))complicationHandler;


/**
 离线geodatabase 文件名

 @return 文件名集合
 */
- (NSArray *)offlineGeodatabaseFileNames;
    
- (NSArray *)loadLayersByLocalShapefiles;
@end

NS_ASSUME_NONNULL_END
