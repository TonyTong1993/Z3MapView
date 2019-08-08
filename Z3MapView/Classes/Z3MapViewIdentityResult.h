//
//  Z3MapViewIdentityResult.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YYKit.h"
NS_ASSUME_NONNULL_BEGIN
@class AGSGeometry;
@interface Z3MapViewIdentityResult : NSObject<YYModel>
/**
 Identity
 */
@property (nonatomic,assign) NSInteger layerId;
@property (nonatomic,copy) NSString *layerName;
@property (nonatomic,copy) NSString *displayFieldName;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *geometryType;
@property (nonatomic,copy) NSDictionary *geometry;


/**
 query
 */
@property (nonatomic,copy) NSDictionary *spatialReference;
@property (nonatomic,copy) NSDictionary *attributes;
@property (nonatomic,copy) NSArray *fields;
@property (nonatomic,copy) NSDictionary *fieldAliases;


/**
 pipe leak,设置显示popUp点的位置
 */
@property (nonatomic,strong) AGSGeometry *displayGeometry;
@property (nonatomic,copy) NSString *value;


//获取IdentityResult的地理信息 构建点类型
- (AGSGeometry *)toGeometry;

/**
 获取导航的目的地

 @return 目的地
 */
- (CLLocation *)destination;


/**
 在Z3HUDIdentityResultViewCell中呈现的字段集合

 @return 字段values集合
 */
- (NSArray *)displayProperties;



@end

NS_ASSUME_NONNULL_END
