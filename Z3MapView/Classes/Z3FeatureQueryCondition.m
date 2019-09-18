//
//  Z3QueryCondition.m
//  AMP
//
//  Created by ZZHT on 2019/7/26.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3FeatureQueryCondition.h"

@implementation Z3PipeNetQueryCondition

@synthesize alias;

@synthesize name;

@end

@implementation Z3FeaturePropertyRelation
@synthesize alias;
@synthesize name;
@end

@implementation Z3FeatureQueryCondition
- (NSArray *)relations {
    if (!_relations) {
        NSMutableArray *temps = [NSMutableArray array];
        Z3FeaturePropertyRelation *condition = [[Z3FeaturePropertyRelation alloc] init];
        condition.alias = @"模糊";
        condition.name = @"like";
        [temps addObject:condition];
        
        condition = [[Z3FeaturePropertyRelation alloc] init];
        condition.alias = @"等于";
        condition.name = @"=";
        [temps addObject:condition];
        
        condition = [[Z3FeaturePropertyRelation alloc] init];
        condition.alias = @"不等于";
        condition.name = @"!=";
        [temps addObject:condition];
        _relations = [temps copy];
    }
    return _relations;
}

@synthesize alias;
@synthesize name;


@end

@implementation Z3FeaturePropertyCondition

@synthesize alias;

@synthesize name;

@end

@implementation Z3StatisitcsPropertyCondition

@synthesize alias;

@synthesize name;


@end
