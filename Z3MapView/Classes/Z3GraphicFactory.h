    //
    //  GraphicFactory.h
    //  OutWork
    //
    //  Created by ZZHT on 2019/5/24.
    //  Copyright © 2019年 ZZHT. All rights reserved.
    //

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSGraphic,Z3FlashGraphic,AGSPoint,AGSPolyline,AGSEnvelope,AGSPolygon,AGSGeometry;
@interface Z3GraphicFactory : NSObject
+ (instancetype)factory;

    /// 创建简单的点类型mark
    /// @param point 点的位置
    /// @param attributes 点属性
- (AGSGraphic *)buildSimpleMarkGraphicWithPoint:(AGSPoint *)point
                                     attributes:(NSDictionary * _Nullable)attributes;

    /// 创建简单的点类型mark
    /// @param point 点的位置
    /// @param color 点颜色
    /// @param attributes 点属性
- (AGSGraphic *)buildSimpleMarkGraphicWithPoint:(AGSPoint *)point
                                          color:(UIColor *)color
                                     attributes:(NSDictionary *)attributes;

    /// 创建简单的线类型mark
    /// @param polyline 线的位置
    /// @param attributes 线属性
- (AGSGraphic *)buildSimpleLineGraphicWithLine:(AGSPolyline *)polyline
                                    attributes:(NSDictionary * _Nullable)attributes;

    /// 创建简单的线类型mark
    /// @param polyline 线的位置
    /// @param color 线颜色
    /// @param attributes 线属性
- (AGSGraphic *)buildSimpleLineGraphicWithLine:(AGSPolyline *)polyline
                                         color:(UIColor *)color
                                    attributes:(NSDictionary * _Nullable)attributes;

- (AGSGraphic *)buildSimpleEnvelopGraphicWithEnvelop:(AGSEnvelope *)envelop
                                          attributes:(NSDictionary * _Nullable)attributes;

- (AGSGraphic *)buildSimplePolygonGraphicWithPolygon:(AGSPolygon *)polygon
                                          attributes:(NSDictionary * _Nullable)attributes;

- (AGSGraphic *)buildSimplePolygonGraphicWithPolygon:(AGSPolygon *)polygon
                                            fillColr:(UIColor *)fillColor
                                          attributes:(NSDictionary *)attributes;

- (AGSGraphic *)buildSimpleGeometryGraphicWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary * _Nullable)attributes;

- (AGSGraphic *)buildSimpleGeometryGraphicWithGeometry:(AGSGeometry *)geometry
                                                 color:(UIColor *)color
                                            attributes:(NSDictionary *)attributes;

- (AGSGraphic *)buildLocationMarkGraphicWithPoint:(AGSPoint *)point
                                       attributes:(NSDictionary * _Nullable)attributes;

    //爆管分析-爆管点
- (AGSGraphic *)buildPipeLeakMarkGraphicWithPoint:(AGSPoint *)point
                                       attributes:(NSDictionary * _Nullable)attributes;
    //爆管分析-阀门
- (AGSGraphic *)buildPipeLeakValvesMarkGraphicWithPoint:(AGSPoint *)point
                                             attributes:(NSDictionary * _Nullable)attributes;
    //地址查询-POI
- (AGSGraphic *)buildPOIGraphicWithPoint:(AGSPoint *)point
                                    text:(NSString *)text
                              attributes:(NSDictionary * _Nullable)attributes;

    //地址查询-POI
- (AGSGraphic *)buildAddressGraphicWithPoint:(AGSPoint *)point
                                  attributes:(NSDictionary * _Nullable)attributes;

/**
 构建文本的graphic
 
 @param point 地图上的位置
 @param text 文字
 @param attributes 属性
 @return graphic
 */
- (AGSGraphic *)buildTextGraphicWithPoint:(AGSPoint *)point
                                     text:(NSString *)text
                               attributes:(NSDictionary * _Nullable)attributes;

/**
 文本AGSGraphic
 
 @param text 需要显示的文字
 @param textColor 文字颜色
 @param fontFamily 字体名
 @param fontSize 字体大小
 @return 文本AGSGraphic
 */

/**
 文本AGSGraphic
 
 @param point 绘制的位置
 @param text 需要显示的文字
 @param textColor 文字颜色
 @param fontFamily 字体名
 @param fontSize 字体大小
 @param attributes 属性
 @return 文本AGSGraphic
 */
- (AGSGraphic *)buildTextGraphicWithPoint:(AGSPoint *)point
                                     text:(NSString *)text
                                textColor:(UIColor *)textColor
                               fontFamily:(NSString *)fontFamily
                                 fontSize:(CGFloat)fontSize
                               attributes:(NSDictionary * _Nullable)attributes;

- (AGSGraphic *)buildTextGraphicWithPoint:(AGSPoint *)point
                                     text:(NSString *)text
                                textColor:(UIColor *)textColor
                               fontFamily:(NSString *)fontFamily
                                 fontSize:(CGFloat)fontSize
                                   offset:(CGPoint)offset
                               attributes:(NSDictionary *)attributes;
/**
 构建线graphic
 
 @param line 线地理信息
 @param color 颜色
 @param width 线款
 @param attributes 属性
 @return graphic
 */
- (AGSGraphic *)buildLineGraphicWithPolyline:(AGSPolyline *)line
                                       color:(UIColor *)color
                                       width:(CGFloat)width
                                  attributes:(NSDictionary * _Nullable)attributes;

/**
 圆、矩形、多边形、箭头的AGSGraphic
 
 @param geometry 填充区域
 @param color 外边线颜色
 @param outLineWidth 外边线宽
 @param fillColor 填充色
 @param attributes 属性
 @return 圆、矩形、多边形、箭头的AGSGraphic
 */
- (AGSGraphic *)buildFillGraphicWithGeometry:(AGSGeometry *)geometry
                                outLineColor:(UIColor *)color
                                outLineWidth:(CGFloat)outLineWidth
                                   fillColor:(UIColor *)fillColor
                                  attributes:(NSDictionary * _Nullable)attributes;


/**
 工程影响范围-选中的阀门的AGSGraphic
 
 @param point 阀门点
 @param attributes 阀门属性
 @return AGSGraphic
 */
- (AGSGraphic *)buildCloseValvesMarkGraphicWithPoint:(AGSPoint *)point
                                          attributes:(NSDictionary * _Nullable)attributes;


/**
 创建书签类型的AGSGraphic
 
 @param point 书签的位置
 @param text 绘制在地图上的文本
 @param attributes 书签的属性
 @return AGSGraphic
 */
- (AGSGraphic *)buildBookMarkGraphicWithPoint:(AGSPoint *)point
                                         text:(NSString * _Nullable)text
                                   attributes:(NSDictionary * _Nullable)attributes;
@end

NS_ASSUME_NONNULL_END
