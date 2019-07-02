//
//  Z3MapOperationBuilder.h
//  OutWork
//
//  Created by 童万华 on 2019/6/27.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3MapViewOperationBuilder : NSObject
+ (instancetype)builder;
- (NSArray *)buildOperations;
@end

NS_ASSUME_NONNULL_END
