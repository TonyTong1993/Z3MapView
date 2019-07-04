//
//  Z3MapViewIdentityContext.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/18.
//  Copyright © 2019 Tony Tony. All rights reserved.
//
#warning "请及时释放Z3MapViewIdentityContext对象"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class AGSMapView,AGSLayer,AGSGeometry,AGSPoint,AGSGraphic,Z3MapViewIdentityContext;

@protocol Z3MapViewIdentityContextDelegate <NSObject>


/**
 返回查询的地理类型

 @param context 当前查询的上下文
 @param screenPoint 点击屏幕的点
 @param mapPoint 地图坐标点
 @return 要查询的地理类型，点，线，envelop,polygon
 */
@optional
- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint;

@optional

/**
 双击查询Identity results graphic

 @param context 当前查询的上下文
 @param screenPoint 点击屏幕的点
 @param mapPoint 地图坐标点
 @param graphic result graphic
 */
- (void)identityContext:(Z3MapViewIdentityContext *)context doubleTapAtScreenPoint:(CGPoint)screenPoint
               mapPoint:(AGSPoint *)mapPoint
                graphic:(AGSGraphic *)graphic;

@optional
/**
 长按查询Identity results graphic
 
 @param context 当前查询的上下文
 @param screenPoint 点击屏幕的点
 @param mapPoint 地图坐标点
 @param graphic result graphic
 */
- (void)identityContext:(Z3MapViewIdentityContext *)context longTapAtScreenPoint:(CGPoint)screenPoint
               mapPoint:(AGSPoint *)mapPoint
                graphic:(AGSGraphic *)graphic;


/**
  返回查询的地理类型

 @param context 当前查询的上下文
 @param screenPoint 点击屏幕的点
 @param mapPoint 地图坐标点
 @param userInfo 附加信息
 @return 要查询的地理类型，点，线，envelop,polygon
 */
@optional
- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint userInfo:(NSDictionary * _Nullable)userInfo;


/**
 额外信息

 @param context 当前查询的上下文
 @return 额外查询讯息
 */
@optional
- (NSDictionary *)userInfoForIdentityContext:(Z3MapViewIdentityContext *)context;


/**
 查询成功的

 @param context 当前查询的上下文
 */
- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context;

/**
 查询失败

 @param context 当前查询的上下文
 */
- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context;
@end

@interface Z3MapViewIdentityContext : NSObject
@property (nonatomic,weak,readonly) AGSMapView *mapView;
@property (nonatomic,weak) id<Z3MapViewIdentityContextDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView;

- (void)setIdentityLayer:(AGSLayer *)layer;

- (void)dissmiss;//清除查询数据，并执行resume操作
- (void)resume;//恢复查询触摸交换事件
- (void)pause;//阻止查询触摸交换事件
- (void)stop;//禁止触摸事件的交换


/**
 开放查询操作

 @param url 查询服务
 @param geometry 地理信息
 @param userInfo 用户额外数据
 */
- (void)identityFeaturesWithGisServer:(NSString *)url
                             geometry:(AGSGeometry *)geometry
                             userInfo:(NSDictionary  * _Nullable )userInfo;


/**
  开放查询操作

 @param url 查询服务地址
 @param geometry 地理信息
 @param tolerance 误差
 @param userInfo 用户额外数据
 */
- (void)identityFeaturesWithGisServer:(NSString *)url
                             geometry:(AGSGeometry *)geometry
                            tolerance:(double)tolerance
                             userInfo:(NSDictionary  * _Nullable )userInfo;
@end

NS_ASSUME_NONNULL_END
