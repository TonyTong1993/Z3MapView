//
//  GraphicFactory.m
//  OutWork
//
//  Created by ZZHT on 2019/5/24.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3GraphicFactory.h"
#import "Z3AGSSymbolFactory.h"
#import "Z3FlashGraphic.h"
@implementation Z3GraphicFactory
+ (instancetype)factory {
    return [[super alloc] init];
}

- (AGSGraphic *)buildSimpleMarkGraphicWithPoint:(AGSPoint *)point attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildNormalPonitSymbol];
    AGSSymbol *selectedSymbol = [[Z3AGSSymbolFactory factory] buildSelectedPonitSymbol];
    Z3FlashGraphic *graphic = [[Z3FlashGraphic alloc] initWithGeometry:point symbol:normalSymbol attributes:attributes];
    [graphic setSelectedSymbol:selectedSymbol];
    [graphic setNormalSymbol:normalSymbol];
    return graphic;
}

- (AGSGraphic *)buildSimpleMarkGraphicWithPoint:(AGSPoint *)point
                                          color:(UIColor *)color
                                     attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildPonitSymbolWithColor:color];
    AGSSymbol *selectedSymbol = [[Z3AGSSymbolFactory factory] buildSelectedPonitSymbol];
    Z3FlashGraphic *graphic = [[Z3FlashGraphic alloc] initWithGeometry:point symbol:normalSymbol attributes:attributes];
    [graphic setSelectedSymbol:selectedSymbol];
    [graphic setNormalSymbol:normalSymbol];
    return graphic;
}

- (AGSGraphic *)buildLocationMarkGraphicWithPoint:(AGSPoint *)point attributes:(NSDictionary *)attributes {
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildLocationSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:symbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildSimpleLineGraphicWithLine:(AGSPolyline *)polyline attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildNormalPolyLineSymbol];
    AGSSymbol *selectedSymbol = [[Z3AGSSymbolFactory factory] buildSelectedPolyLineSymbol];
    Z3FlashGraphic *graphic = [[Z3FlashGraphic alloc] initWithGeometry:polyline symbol:normalSymbol attributes:attributes];
    [graphic setSelectedSymbol:selectedSymbol];
    [graphic setNormalSymbol:normalSymbol];
    return graphic;
}

- (AGSGraphic *)buildSimpleLineGraphicWithLine:(AGSPolyline *)polyline color:(UIColor *)color attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildPolyLineSymbolWithColor:color];
    AGSSymbol *selectedSymbol = [[Z3AGSSymbolFactory factory] buildSelectedPolyLineSymbol];
    Z3FlashGraphic *graphic = [[Z3FlashGraphic alloc] initWithGeometry:polyline symbol:normalSymbol attributes:attributes];
    [graphic setSelectedSymbol:selectedSymbol];
    [graphic setNormalSymbol:normalSymbol];
    return graphic;
}

- (AGSGraphic *)buildSimpleEnvelopGraphicWithEnvelop:(AGSEnvelope *)envelop attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildNormalEnvelopSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:envelop symbol:normalSymbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildSimplePolygonGraphicWithPolygon:(AGSPolygon *)polygon attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildNormalEnvelopSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:polygon symbol:normalSymbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildSimplePolygonGraphicWithPolygon:(AGSPolygon *)polygon color:(UIColor *)color attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildEnvelopSymbolWithColor:color];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:polygon symbol:normalSymbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildSimplePolygonGraphicWithPolygon:(AGSPolygon *)polygon
                                            fillColr:(UIColor *)fillColor
                                          attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildFillSymbolWithColor:fillColor];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:polygon symbol:normalSymbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildSimpleGeometryGraphicWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary *)attributes{
    if ([geometry isKindOfClass:[AGSPoint class]]) {
        return [self buildSimpleMarkGraphicWithPoint:(AGSPoint *)geometry attributes:attributes];
    }else if ([geometry isKindOfClass:[AGSPolyline class]]) {
         return [self buildSimpleLineGraphicWithLine:(AGSPolyline *)geometry attributes:attributes];
    }else if ([geometry isKindOfClass:[AGSPolygon class]]) {
         return [self buildSimplePolygonGraphicWithPolygon:(AGSPolygon *)geometry attributes:attributes];
    }
    NSAssert(nil, @"please check geometry type");
    return nil;
}

- (AGSGraphic *)buildSimpleGeometryGraphicWithGeometry:(AGSGeometry *)geometry
                                                 color:(UIColor *)color
                                            attributes:(NSDictionary *)attributes{
    if ([geometry isKindOfClass:[AGSPoint class]]) {
        return [self buildSimpleMarkGraphicWithPoint:(AGSPoint *)geometry color:color attributes:attributes];
    }else if ([geometry isKindOfClass:[AGSPolyline class]]) {
         return [self buildSimpleLineGraphicWithLine:(AGSPolyline *)geometry color:color attributes:attributes];
    }else if ([geometry isKindOfClass:[AGSPolygon class]]) {
         return [self buildSimplePolygonGraphicWithPolygon:(AGSPolygon *)geometry color:color attributes:attributes];
    }
    NSAssert(nil, @"please check geometry type");
    return nil;
}


- (AGSGraphic *)buildPipeLeakMarkGraphicWithPoint:(AGSPoint *)point attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildPipeLeakNormalSymbol];
    AGSSymbol *selectedSymbol = [[Z3AGSSymbolFactory factory] buildPipeLeakSelectedSymbol];
    Z3FlashGraphic *graphic = [[Z3FlashGraphic alloc] initWithGeometry:point symbol:normalSymbol attributes:attributes];
    [graphic setSelectedSymbol:selectedSymbol];
    [graphic setNormalSymbol:normalSymbol];
    return graphic;
}

- (AGSGraphic *)buildPipeLeakValvesMarkGraphicWithPoint:(AGSPoint *)point
                                             attributes:(NSDictionary * _Nullable)attributes{
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildPipeLeakValvesSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:normalSymbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildCloseValvesMarkGraphicWithPoint:(AGSPoint *)point
                                             attributes:(NSDictionary * _Nullable)attributes{
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildFlagSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:normalSymbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildPOIGraphicWithPoint:(AGSPoint *)point
                                    text:(NSString *)text
                              attributes:(NSDictionary * _Nullable)attributes{
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildPOISymbolWithText:text];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:normalSymbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildPOIGraphicWithLine:(AGSPolyline *)line
                                    text:(NSString *)text
                              attributes:(NSDictionary * _Nullable)attributes{
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildPOISymbolWithText:text];
    AGSGraphic *graphic = [self buildLineGraphicWithPolyline:line color:[UIColor redColor] width:4.0f attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildPOIGraphicWithPolygon:(AGSPolygon *)polygon
                                   text:(NSString *)text
                             attributes:(NSDictionary * _Nullable)attributes{
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildPOISymbolWithText:text];
    UIColor *outLineColor = [UIColor colorWithRed:173/255.0 green:121/255.0 blue:122/255.0 alpha:1.0];
    UIColor *fillColor = [UIColor colorWithRed:173/255.0 green:121/255.0 blue:122/255.0 alpha:0.5];
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildFillSymbolWithOutLineColor:outLineColor outLineWidth:4.0 fillColor:fillColor];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:polygon symbol:symbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildPOIGraphicWithGeometry:(AGSGeometry *)geometry
                                    text:(NSString *)text
                              attributes:(NSDictionary * _Nullable)attributes{
    switch (geometry.geometryType) {
        case AGSGeometryTypePoint:
            return [self buildPOIGraphicWithPoint:(AGSPoint *)geometry text:text attributes:attributes];
            break;
         case AGSGeometryTypePolyline:
            return [self buildPOIGraphicWithLine:(AGSPolyline *)geometry text:text attributes:attributes];
            break;
        case AGSGeometryTypePolygon:
            return [self buildPOIGraphicWithPolygon:(AGSPolygon *)geometry text:text attributes:attributes];
            break;
        default:
            return [self buildSimpleGeometryGraphicWithGeometry:geometry attributes:attributes];
            break;
    }
}

- (AGSGraphic *)buildTextGraphicWithPoint:(AGSPoint *)point
                                    text:(NSString *)text
                              attributes:(NSDictionary * _Nullable)attributes{
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildTextSymbolWithText:text];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:normalSymbol attributes:attributes];
    return graphic;
}



- (AGSGraphic *)buildAddressGraphicWithPoint:(AGSPoint *)point attributes:(NSDictionary *)attributes {
    AGSSymbol *normalSymbol = [[Z3AGSSymbolFactory factory] buildAddressSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:normalSymbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildTextGraphicWithPoint:(AGSPoint *)point
                                     text:(NSString *)text
                                textColor:(UIColor *)textColor
                               fontFamily:(NSString *)fontFamily
                                 fontSize:(CGFloat)fontSize
                               attributes:(NSDictionary *)attributes{
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildTextSymbolWithText:text textColor:textColor fontFamily:fontFamily fontSize:fontSize];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:symbol attributes:attributes];
     return graphic;
}

- (AGSGraphic *)buildTextGraphicWithPoint:(AGSPoint *)point
                                     text:(NSString *)text
                                textColor:(UIColor *)textColor
                               fontFamily:(NSString *)fontFamily
                                 fontSize:(CGFloat)fontSize
                                   offset:(CGPoint)offset
                               attributes:(NSDictionary *)attributes{
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildTextSymbolWithText:text textColor:textColor fontFamily:fontFamily fontSize:fontSize offset:offset];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:symbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildLineGraphicWithPolyline:(AGSPolyline *)line
                                       color:(UIColor *)color
                                       width:(CGFloat)width
                                  attributes:(NSDictionary *)attributes {
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildLineSymbolWithColor:color width:width];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:line symbol:symbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildFillGraphicWithGeometry:(AGSGeometry *)geometry
                                outLineColor:(UIColor *)color
                                outLineWidth:(CGFloat)outLineWidth
                                   fillColor:(UIColor *)fillColor
                                  attributes:(NSDictionary *)attributes {
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildFillSymbolWithOutLineColor:color outLineWidth:outLineWidth fillColor:fillColor];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:geometry symbol:symbol attributes:attributes];
    return graphic;
}

- (AGSGraphic *)buildBookMarkGraphicWithPoint:(AGSPoint *)point text:(NSString *)text attributes:(NSDictionary *)attributes {
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildBookMarkSymbolWithText:text];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:point symbol:symbol attributes:attributes];
    return graphic;
}

/*
 *绘制轨迹
 */

- (AGSGraphic *)buildTraceStartPoint:(AGSPoint *)startPoint {
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildTraceStartSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:startPoint symbol:symbol attributes:@{}];
    return graphic;
}

- (AGSGraphic *)buildTraceEndPoint:(AGSPoint *)endPoint {
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildTraceEndSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:endPoint symbol:symbol attributes:@{}];
    return graphic;
}

- (AGSGraphic *)buildTrace:(AGSPolyline *)trace {
    AGSSymbol *symbol = [[Z3AGSSymbolFactory factory] buildTraceSymbol];
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:trace symbol:symbol attributes:@{}];
    return graphic;
}

@end
