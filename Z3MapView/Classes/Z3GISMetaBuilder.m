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

- (NSString *)allGISMetaLayerIDs {
    NSArray *metas = [Z3MobileConfig shareConfig].gisMetas;
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:@"all:"];
    for (Z3GISMeta *meta in metas) {
        [mstr appendFormat:@"%@,",meta.layerid];
    }
    return mstr;
}


@end
