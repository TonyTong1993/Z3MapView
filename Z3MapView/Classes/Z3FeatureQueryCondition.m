//
//  Z3QueryCondition.m
//  AMP
//
//  Created by ZZHT on 2019/7/26.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3FeatureQueryCondition.h"

@implementation Z3FeatureQueryCondition
- (NSArray *)conditions {
    NSMutableArray *temps = [NSMutableArray array];
    Z3FeatureQueryCondition *condition = [[Z3FeatureQueryCondition alloc] init];
    condition.displayName = @"模糊";
    condition.name = @"like";
    [temps addObject:condition];
    
    condition = [[Z3FeatureQueryCondition alloc] init];
    condition.displayName = @"等于";
    condition.name = @"=";
    [temps addObject:condition];
    
    condition = [[Z3FeatureQueryCondition alloc] init];
    condition.displayName = @"不等于";
    condition.name = @"!=";
    [temps addObject:condition];
    
//    condition = [[Z3FeatureQueryCondition alloc] init];
//    condition.displayName = @"为空";
//    condition.name = @"<";
//    [temps addObject:condition];
//
//    condition = [[Z3FeatureQueryCondition alloc] init];
//    condition.displayName = @"不为空";
//    [temps addObject:condition];
    

    return [temps copy];
    
}
@end
