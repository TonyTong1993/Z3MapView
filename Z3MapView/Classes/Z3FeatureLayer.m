//
//  Z3FeatureLayer.m
//  AMP
//
//  Created by ZZHT on 2019/7/26.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3FeatureLayer.h"
#import "Z3FeatureLayerProperty.h"
@implementation Z3FeatureLayer
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"fields":[Z3FeatureLayerProperty class]};
}
@end
