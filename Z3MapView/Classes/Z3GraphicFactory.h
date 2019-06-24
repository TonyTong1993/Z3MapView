//
//  GraphicFactory.h
//  OutWork
//
//  Created by ZZHT on 2019/5/24.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSGraphic,Z3FlashGraphic,AGSPoint,AGSPolyline,AGSEnvelope;
@interface Z3GraphicFactory : NSObject
+ (instancetype)factory;

- (AGSGraphic *)buildSimpleMarkGraphicWithPoint:(AGSPoint *)point
                                     attributes:(NSDictionary * _Nullable)attributes;
- (AGSGraphic *)buildSimpleLineGraphicWithLine:(AGSPolyline *)polyline
                                     attributes:(NSDictionary * _Nullable)attributes;
- (AGSGraphic *)buildSimpleEnvelopGraphicWithEnvelop:(AGSEnvelope *)envelop
                                          attributes:(NSDictionary * _Nullable)attributes;
@end

NS_ASSUME_NONNULL_END
