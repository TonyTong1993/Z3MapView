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

- (AGSGraphic *)buildSimplePolygonGraphicWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary *)attributes{
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

@end
