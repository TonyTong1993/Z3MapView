//
//  Z3MapViewDisplayIdentityResultContext.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Z3CalloutViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewDisplayIdentityResultContext,Z3MapViewIdentityResult,Z3MapViewPipeAnaylseResult,AGSGraphic,AGSGeometry,AGSPoint;
@protocol Z3MapViewDisplayIdentityResultContextDelegate <NSObject>
- (AGSGraphic *)pointGraphicForDisplayIdentityResultInMapViewWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary *)attributes;
- (AGSGraphic *)polylineGraphicForDisplayIdentityResultInMapViewWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary *)attributes;
- (AGSGraphic *)polygonGraphicForDisplayIdentityResultInMapViewWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary *)attributes;
- (UIView<Z3CalloutViewDelegate> *)calloutViewForDisplayIdentityResultInMapView;
- (AGSPoint *)tapLocationForDisplayCalloutView;
@end


@class AGSMapView;
@interface Z3MapViewDisplayIdentityResultContext : NSObject
@property (nonatomic,weak,readonly) AGSMapView *mapView;
@property (nonatomic,weak,readonly) AGSGraphic *selectedGraphic;
@property (nonatomic,weak) id<Z3MapViewDisplayIdentityResultContextDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView;

/**
 将Identity or Query 接口返回的数据显示到地图上

 @param results 查询数据结果
 @param mapPoint 当前点击的位置
 */
- (void)updateIdentityResults:(NSArray *)results
                     mapPoint:(AGSPoint *)mapPoint;


/**
 将Identity or Query 接口返回的数据显示到地图上

 @param results 查询数据结果
 @param mapPoint 当前点击的位置
 @param showPopup 是否显示popup
 */
- (void)updateIdentityResults:(NSArray *)results
                     mapPoint:(AGSPoint *)mapPoint
                    showPopup:(BOOL)showPopup;

/**
 将爆管分析结果绘制到地图上

 @param result 分析结果
 @param mapPoint 当前点击的位置
 */
- (void)updatePipeAnalyseResult:(Z3MapViewPipeAnaylseResult *)result
                       mapPoint:(AGSPoint * _Nullable)mapPoint;

/**
 将设备选中结果绘制到地图上
 @param result 设备选中结果
 @param mapPoint 点击的位置
 */
- (void)updateDevicePickerResult:(Z3MapViewIdentityResult *)result mapPoint:(AGSPoint * _Nullable)mapPoint;

/**
 将设备选中结果绘制到地图上

 @param result 设备选中结果
 @param mapPoint 点击的位置
 @param showPopup 是否显示popup
 */
- (void)updateDevicePickerResult:(Z3MapViewPipeAnaylseResult *)result
                        mapPoint:(AGSPoint *)mapPoint
                       showPopup:(BOOL)showPopup;

/**
 设置选中的Graphic

 @param graphic 要素
 @param mapPoint 当前点击的位置
 */
- (void)setSelectedIdentityGraphic:(AGSGraphic * _Nullable)graphic
                          mapPoint:(AGSPoint * _Nullable)mapPoint;

/**
 控制是否显示popup view

 @param showPopup default No
 */
- (void)setShowPopup:(BOOL)showPopup;


/**
 移除图层中的所有要素,并隐藏callout
 */
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
