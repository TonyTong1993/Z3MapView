//
//  Z3AGSLayerFactory.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/18.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSBasemap,AGSLayer,AGSArcGISMapImageLayer;
@interface Z3AGSLayerFactory : NSObject
+ (instancetype)factory;
- (NSArray *)loadMapLayers;
- (AGSBasemap *)localBaseMap;
- (AGSLayer *)localBaseMapLayer;
- (void)loadOfflineMapLayersFromGeoDatabase:(void (^)(NSArray *layers))complicationHandler;
- (void)subLayersForOnlineWithAGSArcGISMapImageLayer:(AGSArcGISMapImageLayer *)layer;
- (void)filterSubLayesForOnLineWithAGSArcGISMapImageLayer:(AGSArcGISMapImageLayer *)layer
                                                      ids:(NSArray *)ids
                                                  visible:(BOOL)visible;


- (void)loadOfflineGeoDatabaseWithFileName:(NSString *)fileName
                       complicationHandler:(void (^)(NSArray *layers,NSArray *errors))complicationHandler;


/**
 离线geodatabase 文件名

 @return 文件名集合
 */
- (NSArray *)offlineGeodatabaseFileNames;
@end

NS_ASSUME_NONNULL_END
