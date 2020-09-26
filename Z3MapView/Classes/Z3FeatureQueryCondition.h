//
//  Z3QueryCondition.h
//  AMP
//
//  Created by ZZHT on 2019/7/26.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Z3SelectionOption.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * const LAST_SELECTED_PIPE_NET_CODE;
FOUNDATION_EXTERN NSString * const LAST_SELECTED_PIPE_NET_FEATURE_LAYER_ID;
FOUNDATION_EXTERN NSString * const LAST_SELECTED_PIPE_NET_FEATURE_PROPERTIES;
FOUNDATION_EXTERN NSString * const LAST_SELECTED_PIPE_NET_FEATURE_RELATIONS;
@class Z3FeatureQueryCondition;
//过滤管网的条件
@interface Z3PipeNetQueryCondition : NSObject<Z3SelectionOption>
/**
 管网编号
 */
@property (nonatomic,copy) NSString *code;

/**
 当前管网,可查询的设备要素
 */
@property (nonatomic,copy) NSArray *featureConditions;


    /// 上一次选中的feature图层
@property (nonatomic,strong) Z3FeatureQueryCondition *selectedFeatureQueryCondition;
@end

//过滤设备要素的条件
@interface Z3FeatureQueryCondition : NSObject<Z3SelectionOption>
@property (nonatomic,assign) NSInteger layerid;
@property (nonatomic,assign) NSInteger featureNum;
@property (nonatomic,copy) NSArray *properties;
    /// 上一次选中的feature图层中的属性集合，最多为三种属性
@property (nonatomic,copy) NSArray *selectedProperties;
    /// 上一次选中的feature图层中的属性关系集合，最多为两组关系eg:property1 &&/|| property2
@property (nonatomic,copy) NSArray *selectedPropertyRelations;
@end

@interface Z3FeaturePropertyRelation : NSObject<Z3SelectionOption>

@end

@interface Z3FeaturePropertyCondition : NSObject<Z3SelectionOption,NSCopying>
/**
 1====string 文本
 2====date  日期
 3====下拉
 */
@property (nonatomic,assign) NSInteger disptype;


/**
 esritype 类型的种类 esriFieldTypeString,
 */
@property (nonatomic,copy) NSString *esritype;

@property (nonatomic,copy) NSString *prop;

@property (nonatomic,assign) NSInteger findex;
@property (nonatomic,copy) NSString *displayName;

@property (nonatomic,copy) NSString *statisticType;
/// value 属性值，可以是NSString,NSNumber,Z3FeaturePropertyOption
@property (nonatomic) id value;

@property (nonatomic,copy) NSString *relation;

/**
 可选值
 */
@property (nonatomic,copy) NSArray *selectOptions;

@end

@interface Z3CategoryPropertyRelation : NSObject<Z3SelectionOption>

@end

@interface Z3StatisticsPropertyRelation : NSObject<Z3SelectionOption>

@end

@interface Z3FeaturePropertyOption : NSObject<Z3SelectionOption>

@end
NS_ASSUME_NONNULL_END
