//
//  Z3MapViewPipeAnaylseResult.h
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AGSPolygon;
@interface Z3MapViewPipeAnaylseResult : NSObject
@property (nonatomic,copy) NSDictionary *currEle;

/**
 在元数据中设置了关断特性的设备 可以分为需关和已关
 */
@property (nonatomic,copy) NSArray *valves;

/**
 影响的用户
 */
@property (nonatomic,copy) NSArray *users;

@property (nonatomic,copy) NSArray *influenceUsers;

/**
 影响管段
 */
@property (nonatomic,copy) NSArray *closeLines;

/**
 影响的管点
 */
@property (nonatomic,copy) NSArray *closeNodes;

/**
 影响范围
 */
@property (nonatomic,copy) AGSPolygon *closearea;

@end

NS_ASSUME_NONNULL_END
