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
@class AGSMapView,AGSLayer,AGSGeometry,AGSPoint,AGSGraphic,Z3MapViewIdentityContext,Z3MapViewPipeAnaylseResult;

@protocol Z3MapViewIdentityContextDelegate <NSObject>

/**
 返回查询的地理类型

 @param context 当前查询的上下文
 @param screenPoint 点击屏幕的点
 @param mapPoint 地图坐标点
 @return 要查询的地理类型，点，线，envelop,polygon
 */
@optional
- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context
             didTapAtScreenPoint:(CGPoint)screenPoint
                        mapPoint:(AGSPoint *)mapPoint;

@optional

/**
 双击查询Identity results graphic

 @param context 当前查询的上下文
 @param screenPoint 点击屏幕的点
 @param mapPoint 地图坐标点
 @param graphic result graphic
 */
- (void)identityContext:(Z3MapViewIdentityContext *)context
 doubleTapAtScreenPoint:(CGPoint)screenPoint
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
- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context identityResults:(NSArray *)results;

/**
 查询失败

 @param context 当前查询的上下文
 */
- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context;


/**
 爆管分析查询成功

 @param context 当前查询的上下文
 @param result 分析结果
 */
- (void)identityContextPipeAnaylseSuccess:(Z3MapViewIdentityContext *)context
                        pipeAnaylseResult:(Z3MapViewPipeAnaylseResult *)result;

/**
 查询失败
 
 @param context 当前查询的上下文
 */
- (void)identityContextPipeAnaylseFailure:(Z3MapViewIdentityContext *)context;


/**
 当查询到数据后,点击地图触发对graphic的查询

 @param graphic 查询结果列表中的第一个
 */
- (void)identityGraphicSuccess:(AGSGraphic *)graphic;

/**
 当查询到数据后,点击地图触发对graphic的查询
 */
- (void)identityGraphicFailure;

@end

/**
 GIS 查询模式 分为 Identity和Query接口

 - Z3MapViewIdentityContextModeIdentity: identity 模式
 - Z3MapViewIdentityContextModeQuery: query 模式
 */
typedef NS_ENUM(NSUInteger,Z3MapViewIdentityContextMode) {
    Z3MapViewIdentityContextModeIdentity,
    Z3MapViewIdentityContextModeQuery
};

@interface Z3MapViewIdentityContext : NSObject
@property (nonatomic,weak,readonly) AGSMapView *mapView;
@property (nonatomic,weak) id<Z3MapViewIdentityContextDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView;

- (void)setIdentityURL:(NSString *)url;//设置查询的URL
- (void)setIdentityLayer:(AGSLayer *)layer;//设置查询的图层

/**
 查询结果是否显示popup

 @param showPopup default YES
 */
- (void)setDisplayPopup:(BOOL)showPopup;

- (void)setMode:(Z3MapViewIdentityContextMode)mode;

- (void)clear;//清除查询数据，并执行resume操作,如果当前正在查询，则不处理响应
- (void)dissmiss;//清除数据，结束查询
- (void)resume;//恢复查询触摸交换事件
- (void)pause;//阻止查询触摸交换事件
- (void)stop;//禁止触摸事件的交换


/**
 默认查询

 @param geometry 地理信息
 @param userInfo 用户额外数据
 */
- (void)identifyGeometry:(AGSGeometry *)geometry userInfo:(NSDictionary * _Nullable)userInfo;


/**
 指定图层的query

 @param geometry 查询范围
 @param userInfo 用户额外数据
 */
- (void)queryFeaturesWithGeometry:(AGSGeometry *)geometry userInfo:(NSDictionary *)userInfo;

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


/**
 开放爆管分析操作

 @param url 爆管分析的URL
 @param geometry 爆管点
 @param userInfo  用户额外数据
 */
- (void)pipeAnalyseFeatureWithGisServer:(NSString *)url
                               geometry:(AGSGeometry *)geometry
                               userInfo:(NSDictionary *)userInfo;


/**
 设置点击查询,是否排除管线查询

 @param exclude 默认为NO
 */
- (void)setIdentityExcludePipeline:(Boolean)exclude;
@end

NS_ASSUME_NONNULL_END
