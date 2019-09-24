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
#import "Z3StatisticsConfigurationFacotry.h"
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

- (NSArray *)buildPipeNetQueryConditions {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSMutableArray *sections = [NSMutableArray array];
    for (Z3GISMeta *meta in metas) {
        NSArray *features = meta.net;
        if (features.count) {
            Z3PipeNetQueryCondition *pipeNetCondition = [[Z3PipeNetQueryCondition alloc] init];
            pipeNetCondition.code = meta.code;
            pipeNetCondition.alias = meta.layername;
            NSMutableArray *featureConditions = [NSMutableArray array];
            for (Z3FeatureLayer *feature in features) {
                Z3FeatureQueryCondition *condition = [[Z3FeatureQueryCondition alloc] init];
                condition.name = feature.dname;
                condition.alias = feature.dname;
                condition.layerid = feature.layerid;
                condition.featureNum = feature.dno;
                NSArray *properties = [self buildFeaturePropertyConditionsWithFields:feature.fields];
                condition.properties = properties;
                [featureConditions addObject:condition];
            }
            pipeNetCondition.featureConditions = [featureConditions copy];
            [sections addObject:pipeNetCondition];
        }
    }
    
    return [sections copy];
}

- (NSArray *)buildFeaturePropertyConditionsWithFields:(NSArray *)fields {
    NSMutableArray *conditons = [NSMutableArray array];
    for (Z3FeatureLayerProperty *obj in fields) {
        if ([obj.alias isChinese]) {
            Z3FeaturePropertyCondition *condition = [[Z3FeaturePropertyCondition alloc] init];
            condition.name = obj.name;
            condition.alias = obj.alias;
            condition.findex = obj.findex;
            condition.disptype = obj.disptype;
            condition.esritype = obj.esritype;
            condition.prop = obj.prop;
            [conditons addObject:condition];
        }
    }
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
        if (meta.type != 4) {
            continue;
        }
        
        //澳门管网的code
        if (![meta.code isEqualToString:@"MWGS"]) {
            continue;
        }
        
        [meta.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.geotype == 0) {
                layerID = [NSString stringWithFormat:@"%ld",obj.layerid];
                *stop = YES;
            }
        }];
    }
    return layerID;
}

- (NSArray *)pipeLayerIDsWithJS:(NSString *)js {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSMutableArray *layers =[[NSMutableArray alloc] init];
    for (Z3GISMeta *meta in metas) {
        if ([meta.layername isEqualToString:js]) {
            [meta.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.geotype == 0) {
                    NSDictionary *info = @{
                                           @"layerID":@(obj.layerid),
                                           @"name":obj.dname ?: @"",
                                           @"alias":obj.dname ?: @""
                                           };
                    [layers addObject:info];
                }
            }];
            
            break;
        }
    }
    return layers;
}

- (NSString *)closeableValveLayerIDs {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSMutableArray *valveLayerIDs = [[NSMutableArray alloc] init];
    for (Z3GISMeta *meta in metas) {
        if (meta.type != 4) {
            continue;
        }
        
        //澳门管网的code
        if (![meta.code isEqualToString:@"MWGS"]) {
            continue;
        }
        
        [meta.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.bsprop == 1) {
               NSString*layerID = [NSString stringWithFormat:@"%ld",obj.layerid];
                [valveLayerIDs addObject:layerID];
            }
        }];
    }
    NSString *ids = [valveLayerIDs componentsJoinedByString:@","];
    NSString *result = [NSString stringWithFormat:@"all:%@",ids];
    return result;
}

- (NSArray *)valveLayerIDs {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    __block NSString *layerID = @"";
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (Z3GISMeta *meta in metas) {
        [meta.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.bsprop == 1) {
                layerID = [NSString stringWithFormat:@"%ld",obj.layerid];
                [results addObject:layerID];
            }
        }];
    }
    return results;
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

- (NSString *)layerIdWithDNO:(NSString *)dno {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    __block NSString *layerId = nil;
    [metas enumerateObjectsUsingBlock:^(Z3GISMeta *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *features = obj.net;
        [features enumerateObjectsUsingBlock:^(Z3FeatureLayer *feature, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([dno integerValue] == feature.dno) {
                layerId = [@(feature.layerid) stringValue];
                *stop = YES;
            }
        }];
        if (layerId != nil) {
            *stop = YES;
        }
    }];
    
    return layerId;
}

- (NSArray *)metaInfosWithNetNotEmpty {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:metas.count];
    [metas enumerateObjectsUsingBlock:^(Z3GISMeta *meta, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([meta.net count]) {
            [results addObject:meta];
            *stop = YES;
        }
    }];
    return results;
}

- (NSArray *)pipeLinesWithCode:(NSString *)code {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [[self metaInfosWithNetNotEmpty] enumerateObjectsUsingBlock:^(Z3GISMeta *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.code isEqualToString:code]) {
            [obj.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *featureLayer, NSUInteger idx, BOOL * _Nonnull stop) {
                if (featureLayer.geotype == 0) {
                    [results addObject:featureLayer];
                }
            }];
            *stop = YES;
        }
    }];
    return results;
}

- (NSArray *)devicesWithCode:(NSString *)code {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [[self metaInfosWithNetNotEmpty] enumerateObjectsUsingBlock:^(Z3GISMeta *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.code isEqualToString:code]) {
            [obj.net enumerateObjectsUsingBlock:^(Z3FeatureLayer *featureLayer, NSUInteger idx, BOOL * _Nonnull stop) {
                if (featureLayer.geotype == 1) {
                    [results addObject:featureLayer];
                }
            }];
            *stop = YES;
        }
    }];
    return results;
}

- (NSString *)deviceLayerIds {
    NSString *jsName = [Z3StatisticsConfigurationFacotry factory].jsName;
    NSArray *results = [self devicesWithCode:jsName];
    NSArray *layerIds = [results valueForKey:@"layerid"];
    return   [layerIds componentsJoinedByString:@","];
}

- (NSString *)bookMarkLayerId {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSString *layerId = nil;
    for (Z3GISMeta *meta in metas) {
        if ([meta.code isEqualToString:@"MARKER"]) {
            layerId = meta.layerid;
            break;
        }
        
    }
    return layerId;
}

@end
