//
//  Z3StatisticsConfigurationFacotry.h
//  AMP
//
//  Created by ZZHT on 2019/9/4.
//  Copyright © 2019年 ZZHT. All rights reserved.
/*
 *统计配置数据获取的工厂类
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3StatisticsConfigurationFacotry : NSObject
+ (instancetype)factory;

/**
 获取数据统计的统计模型集合
 @return 需要统计的集合
 */
- (NSArray *)allStatistics;
/**
 得到管径字段名

 @return name
 */
- (NSString *)pipeDiameterName;


/**
 得到材质字段名

 @return name
 */
- (NSString *)materialName;



/**
 得到长度字段名

 @return name
 */
- (NSString *)lengthName;


/**
 得到道路字段名

 @return name
 */
- (NSString *)roadName;


/**
 得到城市名

 @return name
 */
- (NSString *)cityName;

/**
 得到供水管网code标识默认为JS

 @return name
 */
- (NSString *)jsName;

@end

NS_ASSUME_NONNULL_END
