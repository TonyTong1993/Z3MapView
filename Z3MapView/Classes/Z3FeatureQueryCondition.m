//
//  Z3QueryCondition.m
//  AMP
//
//  Created by ZZHT on 2019/7/26.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3FeatureQueryCondition.h"

NSString * const LAST_SELECTED_PIPE_NET_CODE = @"last.selected.pipe.net.code";
NSString * const LAST_SELECTED_PIPE_NET_FEATURE_LAYER_ID = @"last.selected.pipe.net.feature.layerid";
NSString * const LAST_SELECTED_PIPE_NET_FEATURE_PROPERTIES = @"last.selected.pipe.net.feature.properties";
NSString * const LAST_SELECTED_PIPE_NET_FEATURE_RELATIONS = @"last.selected.pipe.net.feature.relations";

@implementation Z3PipeNetQueryCondition

@synthesize alias;

@synthesize name;

@end

@implementation Z3FeaturePropertyRelation
@synthesize alias;
@synthesize name;
@end

@implementation Z3FeatureQueryCondition

@synthesize alias;
@synthesize name;


@end

@implementation Z3FeaturePropertyCondition

@synthesize alias;

@synthesize name;

- (id)copyWithZone:(NSZone *)zone {
    Z3FeaturePropertyCondition *newInstance = [[Z3FeaturePropertyCondition alloc] init];
    newInstance.name = self.name;
    newInstance.alias = self.alias;
    newInstance.esritype = self.esritype;
    newInstance.prop = self.prop;
    newInstance.findex = self.findex;
    newInstance.displayName = self.displayName;
    newInstance.statisticType = self.statisticType;
    newInstance.value = self.value;
    newInstance.relation = self.relation;
    newInstance.selectOptions = self.selectOptions;
    newInstance.disptype = self.disptype;
    return newInstance;
}

@end

@implementation Z3CategoryPropertyRelation

@synthesize alias;

@synthesize name;


@end

@implementation Z3StatisticsPropertyRelation

@synthesize alias;

@synthesize name;


@end

@implementation Z3FeaturePropertyOption

@synthesize alias;

@synthesize name;


@end
