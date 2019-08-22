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
- (AGSSymbol *)buildSelectedPonitSymbol;
- (AGSSymbol *)buildSelectedPolyLineSymbol;
- (AGSSymbol *)buildNormalPolyLineSymbol;
- (AGSSymbol *)buildNormalPolygonSymbol;
- (AGSSymbol *)buildNormalEnvelopSymbol;

    //创建SketchEditor模式下，select vet点x样式
- (AGSSymbol *)buildSelectedVertexSymbol;
    //创建SketchEditor模式下，normal点x样式
- (AGSSymbol *)buildNormalVertexSymbol;
    //创建SketchEditor模式下，end点x样式
- (AGSSymbol *)buildMidVertexSymbol;

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

- (AGSSymbol *)buildLocationSymbol;

//爆管分析-爆管点处的symbol
- (AGSSymbol *)buildPipeLeakNormalSymbol;
- (AGSSymbol *)buildPipeLeakSelectedSymbol;
//爆管分析-爆管点关联的阀门symbol
- (AGSSymbol *)buildPipeLeakValvesSymbol;
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
@end

NS_ASSUME_NONNULL_END
