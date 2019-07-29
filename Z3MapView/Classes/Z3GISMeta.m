//
//  Z3GISMeta.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3GISMeta.h"
#import "Z3FeatureLayer.h"
@implementation Z3GISMeta
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"net":[Z3FeatureLayer class]};
}
@end
