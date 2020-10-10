//
//  Z3AGSSymbolFactory.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//收拢app中的AGSSymbol的创建

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSSymbol;
@interface Z3AGSSymbolFactory : NSObject
+ (instancetype)factory;

- (AGSSymbol *)buildNormalPonitSymbol;
- (AGSSymbol *)buildPonitSymbolWithColor:(UIColor *)color;
- (AGSSymbol *)buildSelectedPonitSymbol;
- (AGSSymbol *)buildSelectedPolyLineSymbol;
- (AGSSymbol *)buildNormalPolyLineSymbol;
- (AGSSymbol *)buildPolyLineSymbolWithColor:(UIColor *)color;
- (AGSSymbol *)buildNormalPolygonSymbol;
- (AGSSymbol *)buildNormalEnvelopSymbol;
- (AGSSymbol *)buildEnvelopSymbolWithColor:(UIColor *)color;


/// 拉框查询，顶点AGSSymbol
- (AGSSymbol *)buildVertexForRectSymbol;
    //创建SketchEditor模式下，select 顶点样式
- (AGSSymbol *)buildSelectedVertexSymbol;
    //创建SketchEditor模式下，normal点x样式
- (AGSSymbol *)buildNormalVertexSymbol;
    //创建SketchEditor模式下，end点x样式
- (AGSSymbol *)buildSelectedMidVertexSymbol;
- (AGSSymbol *)buildNormalMidVertexSymbol;

/**
 设置SketchEditor模式下,FillSymbol

 @param color 填充色
 @return FillSymbol
 */
- (AGSSymbol *)buildFillSymbolWithColor:(UIColor *)color;

//Show User Location
- (AGSSymbol *)buildAccuracySymbol;
- (AGSSymbol *)buildAcquiringSymbol;
- (AGSSymbol *)buildPingAnimationSymbol;
- (AGSSymbol *)buildCourseSymbol;
- (AGSSymbol *)buildDefaultSymbol;
- (AGSSymbol *)buildHeadingSymbol;
//当前定位点symbol
- (AGSSymbol *)buildLocationSymbol;
//爆管分析-爆管点处的symbol
- (AGSSymbol *)buildPipeLeakNormalSymbol;
- (AGSSymbol *)buildPipeLeakSelectedSymbol;

/**
 创建🚩AGSSymbol,目前在澳门工程影响范围,点选阀门后使用到这个AGSSymbol

 @return AGSSymbol
 */
- (AGSSymbol *)buildFlagSymbol;
//爆管分析-爆管点关联的阀门symbol
- (AGSSymbol *)buildPipeLeakValvesSymbol;

/**
 显示POI的AGSSymbol

 @param text 文本
 @return AGSSymbol
 */
- (AGSSymbol *)buildPOISymbolWithText:(NSString *)text;

/**
 显示位置的AGSSymbol

 @return AGSSymbol
 */
- (AGSSymbol *)buildAddressSymbol;


/**
 文本symbol

 @param text 需要显示的文字
 @return 文本symbol
 */
- (AGSSymbol *)buildTextSymbolWithText:(NSString *)text;

/**
 文本symbol

 @param text 需要显示的文字
 @param textColor 文字颜色
 @param fontFamily 字体名
 @param fontSize 字体大小
 @return 文本symbol
 */
- (AGSSymbol *)buildTextSymbolWithText:(NSString *)text
                             textColor:(UIColor *)textColor
                            fontFamily:(NSString *)fontFamily
                              fontSize:(CGFloat)fontSize;

- (AGSSymbol *)buildTextSymbolWithText:(NSString *)text
                             textColor:(UIColor *)textColor
                            fontFamily:(NSString *)fontFamily
                              fontSize:(CGFloat)fontSize
                                offset:(CGPoint)offset;

/**
  线symbol

 @param color 线颜色
 @param width 线的宽度
 @return  线symbol
 */
- (AGSSymbol *)buildLineSymbolWithColor:(UIColor *)color
                                  width:(CGFloat)width;

/**
 圆、矩形、多边形、箭头的AGSSymbol

 @param color 外边线颜色
 @param outLineWidth 外边线宽
 @param fillColor 填充色
 @return 圆、矩形、多边形、箭头的AGSSymbol
 */
- (AGSSymbol *)buildFillSymbolWithOutLineColor:(UIColor *)color
                                  outLineWidth:(CGFloat)outLineWidth
                                     fillColor:(UIColor *)fillColor;


/**
 构建书签的AGSSymbol

 @param text 显示的文本
 @return Symbol
 */
- (AGSSymbol *)buildBookMarkSymbolWithText:(NSString *)text;

- (AGSSymbol *)buildTraceStartSymbol;

- (AGSSymbol *)buildTraceEndSymbol;

- (AGSSymbol *)buildTraceSymbol;

- (AGSSymbol *)buildSymbolWithTitleAndContent:(NSString *)title content:(NSString *)content;

- (AGSSymbol *)buildPointNormalSymbolWithImage;
- (AGSSymbol *)buildPointNormalSymbolWithImageAndText:(NSString *)text;

- (AGSSymbol *)buildPointHighlightSymbolWithImage;
- (AGSSymbol *)buildPointHighlightSymbolWithImageAndText:(NSString *)text;

- (AGSSymbol *)buildPointHighlightSymbolWithYellowImage;
- (AGSSymbol *)buildPointHighlightSymbolWithYellowImageAndText:(NSString *)text;


- (AGSSymbol *)buildHighlightEnvelopSymbol;
- (AGSSymbol *)buildYellowEnvelopSymbol;

- (AGSSymbol *)buildNormalEnvelopSymbolWithText:(NSString *)text ;

- (AGSSymbol *)buildHighlightEnvelopSymbolWithText:(NSString *)text ;

- (AGSSymbol *)buildYellowEnvelopSymbolWithText:(NSString *)text ;

- (AGSSymbol *)buildMyLocationSymbolWithText;
@end

NS_ASSUME_NONNULL_END
