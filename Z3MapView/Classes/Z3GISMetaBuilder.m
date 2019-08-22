//
//  Z3DeviceMetaBuilder.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3GISMetaBuilder.h"
#import "Z3MobileConfig.h"
#import "Z3GISMeta.h"
#import "Z3FeatureLayer.h"
#import "Z3FeatureLayerProperty.h"
#import "Z3FeatureQueryCondition.h"
#import "NSString+Chinese.h"
@implementation Z3GISMetaBuilder
+ (instancetype)builder {
    return [[super alloc] init];
}
- (NSDictionary *)buildDeviceMetaWithTargetLayerName:(NSString *)layerName targetLayerId:(NSInteger)layerId {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSString *pLayerName = [[layerName componentsSeparatedByString:@"_"] firstObject];
    __block Z3GISMeta *targetMeta = nil;
    [metas enumerateObjectsUsingBlock:^(Z3GISMeta *meta, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([meta.layername isEqualToString:pLayerName]) {
            targetMeta = meta;
            *stop = YES;
        }
    }];
    NSAssert(targetMeta, @"not find meta in config xml");
    __block NSDictionary *deviceInfo = nil;
    [targetMeta.net enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"layerid"] integerValue] == layerId) {
            deviceInfo = obj;
            *stop = YES;
        }
    }];
    NSAssert(deviceInfo, @"not find device info in config xml");
    return deviceInfo;
}

- (Z3FeatureLayer *)aomen_buildDeviceMetaWithTargetLayerName:(NSString *)layerName targetLayerId:(NSInteger)layerId {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSString *pLayerName = [[layerName componentsSeparatedByString:@"_"] firstObject];
    __block Z3GISMeta *targetMeta = nil;
    [metas enumerateObjectsUsingBlock:^(Z3GISMeta *meta, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([meta.layername isEqualToString:pLayerName]) {
            targetMeta = meta;
            *stop = YES;
        }
    }];
    NSAssert(targetMeta, @"not find meta in config xml");
    __block Z3FeatureLayer *deviceInfo = nil;
    [targetMeta.net enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Z3FeatureLayer *feature, NSUInteger idx, BOOL * _Nonnull stop) {
        if (feature.layerid  == layerId) {
            deviceInfo = feature;
            *stop = YES;
        }
    }];
    NSAssert(deviceInfo, @"not find device info in config xml");
    return deviceInfo;
}

- (NSArray *)buildFeatureQueryConditions {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSMutableArray *conditons = [NSMutableArray array];
    [metas enumerateObjectsUsingBlock:^(Z3GISMeta *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *features = obj.net;
        [features enumerateObjectsUsingBlock:^(Z3FeatureLayer *feature, NSUInteger idx, BOOL * _Nonnull stop) {
            Z3FeatureQueryCondition *condition = [[Z3FeatureQueryCondition alloc] init];
            condition.name = feature.dname;
            condition.displayName = feature.dname;
            condition.findex = idx;
            condition.featureId = feature.layerid;
            condition.featureNum = feature.dno;
            NSArray *sunConditions = [self buildSubConditionsWithFields:feature.fields];
            condition.properties = sunConditions;
            [conditons addObject:condition];
        }];
    }];
    return conditons;
}

- (NSArray *)buildSubConditionsWithFields:(NSArray *)fields {
     NSMutableArray *conditons = [NSMutableArray array];
    [fields enumerateObjectsUsingBlock:^(Z3FeatureLayerProperty *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.alias isChinese]) {
            Z3FeatureQueryCondition *condition = [[Z3FeatureQueryCondition alloc] init];
            condition.name = obj.name;
            condition.displayName = obj.alias;
            condition.findex = obj.findex;
            [conditons addObject:condition];
        }
    }];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"findex" ascending:YES];
    return [conditons sortedArrayUsingDescriptors:@[sort]];
}


- (NSString *)allGISMetaLayerIDs {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:@"all:"];
    for (Z3GISMeta *meta in metas) {
        [meta.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mstr appendFormat:@"%ld,",obj.layerid];
        }];
    }
    return mstr;
}

- (NSString *)allExcludePipelineLayerIDs {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:@"all:"];
    for (Z3GISMeta *meta in metas) {
        [meta.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
#warning 获取管段的图层ID因项目而定
            if (![obj.dname isEqualToString:@"PIPE"]) {
                [mstr appendFormat:@"%ld,",obj.layerid];
            }
        }];
    }
    return mstr;
}

- (NSString *)pipeLayerID {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    __block NSString *layerID = @"";
    for (Z3GISMeta *meta in metas) {
        [meta.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
#warning 获取管段的图层ID因项目而定
            if ([obj.dname isEqualToString:@"PIPE"]) {
                layerID = [NSString stringWithFormat:@"%ld,",obj.layerid];
            }
        }];
    }
    return layerID;
}

#warning 获取阀门ID ID从元数据中获取
- (NSInteger )valveLayerID {
    return 1;
}

- (NSInteger )gisErrorReportLayerID {
     NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    __block NSInteger layerID = -1;
    [metas enumerateObjectsUsingBlock:^(Z3GISMeta *meta, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([meta.layername isEqualToString:@"GISERRORREPORT"]) {
            layerID = [meta.layerid integerValue];
            *stop = YES;
        }
    }];
    return layerID;
}

@end
