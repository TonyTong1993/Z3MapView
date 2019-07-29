//
//  Z3MapViewRectQueryXtd.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewCommonQueryXtd.h"

NS_ASSUME_NONNULL_BEGIN

@interface Z3MapViewRectQueryXtd : Z3MapViewCommonQueryXtd

- (void)setArguments:(NSDictionary *)arguments;
- (void)registerQueryComplcation:(void (^)(NSArray * _Nullable results,NSError * _Nullable error))complcation;
@end

NS_ASSUME_NONNULL_END
