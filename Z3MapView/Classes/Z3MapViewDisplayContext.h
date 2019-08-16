//
//  Z3MapViewDisplayContext.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/18.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Z3MapViewLayerFilterView.h"
#import "Z3MapOperationView.h"
#import "Z3MapViewOperationDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@class AGSMapView,AGSEnvelope,AGSPoint;
typedef void(^MapViewLoadStatusListener)(NSInteger status);

@interface Z3MapViewDisplayContext : NSObject
@property (nonatomic,weak,readonly) AGSMapView *mapView;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView;

//设置map layer load status listener
- (void)setMapViewLoadStatusListener:(MapViewLoadStatusListener)listener;

//设置mapView viewpoint
- (void)zoomIn;
- (void)zoomOut;
- (void)zoomToEnvelope:(AGSEnvelope *)envelop;
- (void)zoomToPoint:(AGSPoint *)point withScale:(double)scale;
- (void)zoomToInitialEnvelop;

/**
  显示中心点所在位置的控件
 */
- (void)showCenterPropertyView;
/**
 弹窗图层控制的popup view

 @param dataSource 图层数据源
 @param delegate 操作delegate
 */

- (void)showLayerFilterPopUpViewWithDataSource:(NSArray *)dataSource delegate:(id<Z3MapViewOperationDelegate>)delegate;


/**
 弹窗显示操作按钮视图

 @param dataSource 操作数据源
 @param delegate 操作delegate
 */
- (void)showMapOpertionViewWithDataSource:(NSArray *)dataSource delegate:(id<Z3MapViewOperationDelegate>)delegate;


/**
 弹窗Graphics控制的popup view
 
 @param dataSource Graphics类型数据源
 @param delegate 操作delegate
 */

- (void)showGraphicsFilterPopUpViewWithDataSource:(NSArray *)dataSource delegate:(id<Z3MapViewOperationDelegate>)delegate;


/**
 显示位置到地图上  使用场景,事件管理->点击位置按钮

 @param address 地址
 @param location map 上的位置
 */
- (void)showAddress:(NSString *)address location:(AGSPoint *)location;

/**
 移除位置AnotationView
 */
- (void)removeAddressAnotationView;

@end

NS_ASSUME_NONNULL_END
