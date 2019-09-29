//
//  Z3FeatureLayerProperty.h
//  AMP
//
//  Created by ZZHT on 2019/7/26.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3FeatureLayerProperty : NSObject
@property (nonatomic,copy) NSString *alias;
@property (nonatomic,copy) NSString *esritype;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *dname;
@property (nonatomic,copy) NSString *prop;

/**
 下拉可选值
 */
@property (nonatomic,copy) NSArray *values;


/**
 1====string 文本
 2====date  日期
 3====下拉
 */
@property (nonatomic,assign) NSInteger disptype;
@property (nonatomic,copy) NSString *defval;
@property (nonatomic,copy) NSString *displayValue;
@property (nonatomic,assign) NSInteger findex;
@end
NS_ASSUME_NONNULL_END
