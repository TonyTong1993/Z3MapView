//
//  Z3OneStatistics.h
//  AMP
//
//  Created by ZZHT on 2019/9/4.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger,Z3OneStatisticsType) {
    Z3OneStatisticsTypePipe,//管线统计
    Z3OneStatisticsTypeDevice//设备统计
};
@class Z3StatisticsLegend;
@interface Z3OneStatistics : NSObject
@property (nonatomic,copy) NSString *title;

/**
 可切换统计内容的字段
 */
@property (nonatomic,copy) NSArray *switchFields;


/**
 筛选需要统计的设备
 */
@property (nonatomic,copy) NSArray *deviceFilters;


/**
 统计图例信息
 */
@property (nonatomic,strong) Z3StatisticsLegend *legend;


/**
 统计类型
 */
@property (nonatomic,assign) Z3OneStatisticsType type;
@end

NS_ASSUME_NONNULL_END
