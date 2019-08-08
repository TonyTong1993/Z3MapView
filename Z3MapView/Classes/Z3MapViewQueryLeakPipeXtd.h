//
//  Z3MapViewQueryLeakPipeXtd.h
//  AFNetworking
//
//  Created by 童万华 on 2019/7/4.
//爆管分析

#import "Z3MapViewTapQueryXtd.h"

NS_ASSUME_NONNULL_BEGIN

@interface Z3MapViewQueryLeakPipeXtd : Z3MapViewTapQueryXtd


/**
 关阀搜索

 @param valveNods 二次关阀的阀门GID
 */
- (void)searchRelativeValves:(NSString * _Nullable)valveNods;
@end

NS_ASSUME_NONNULL_END
