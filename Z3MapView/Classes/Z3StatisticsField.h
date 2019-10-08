//
//  Z3StatisticsField.h
//  AMP
//
//  Created by ZZHT on 2019/9/3.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Z3SelectionOption.h"
NS_ASSUME_NONNULL_BEGIN
@class Z3StatisticsLegend;
@interface Z3StatisticsField : NSObject
@property (nonatomic,copy) NSString *title;

/**
 统计相关的字段
 */
@property (nonatomic,copy) NSString *group;

@property (nonatomic,copy) NSString *outFields;

@property (nonatomic,copy) NSArray *outStatistics;

@end

@interface Z3StatisticsDeviceFilter : NSObject<Z3SelectionOption>

/**
 设备图层ID
 */
@property (nonatomic,assign) NSInteger layerID;

@end

NS_ASSUME_NONNULL_END
