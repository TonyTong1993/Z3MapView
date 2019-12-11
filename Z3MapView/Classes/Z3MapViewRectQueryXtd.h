//
//  Z3MapViewRectQueryXtd.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewCommonQueryXtd.h"
#import <PromiseKit.h>
typedef void(^MakeRectComplication)(NSDictionary *geometry,NSError *error);
NS_ASSUME_NONNULL_BEGIN
@interface Z3MapViewRectQueryXtd : Z3MapViewCommonQueryXtd

/**
 active默认YES,即获取到范围后就立即进行查询操作
 */
@property (nonatomic,assign) BOOL active;

- (void)setArguments:(NSDictionary *)arguments;
- (void)registerQueryComplcation:(void (^)(NSArray * _Nullable results,NSDictionary * _Nullable geometry,NSError * _Nullable error))complcation;
- (void)registerMakeRectComplcation:(MakeRectComplication)complcation;
@end


@interface Z3MapViewRectQueryXtd (Form)

@end

NS_ASSUME_NONNULL_END
