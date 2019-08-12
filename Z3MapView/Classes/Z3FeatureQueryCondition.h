//
//  Z3QueryCondition.h
//  AMP
//
//  Created by ZZHT on 2019/7/26.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3FeatureQueryCondition : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger featureId;
@property (nonatomic,assign) NSInteger featureNum;
@property (nonatomic,assign) NSInteger findex;
@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSArray *properties;
@property (nonatomic,copy) NSArray *conditions;
@end

NS_ASSUME_NONNULL_END
