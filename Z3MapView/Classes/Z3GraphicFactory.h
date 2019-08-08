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

- (AGSGraphic *)buildSimpleMarkGraphicWithPoint:(AGSPoint *)point
                                     attributes:(NSDictionary * _Nullable)attributes;
- (AGSGraphic *)buildSimpleLineGraphicWithLine:(AGSPolyline *)polyline
                                     attributes:(NSDictionary * _Nullable)attributes;
- (AGSGraphic *)buildSimpleEnvelopGraphicWithEnvelop:(AGSEnvelope *)envelop
                                          attributes:(NSDictionary * _Nullable)attributes;
- (AGSGraphic *)buildSimplePolygonGraphicWithPolygon:(AGSPolygon *)polygon
                                          attributes:(NSDictionary *)attributes;
- (AGSGraphic *)buildSimplePolygonGraphicWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary *)attributes;

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
@end

NS_ASSUME_NONNULL_END
