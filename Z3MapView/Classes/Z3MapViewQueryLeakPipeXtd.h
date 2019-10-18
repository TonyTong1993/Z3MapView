//
//  Z3MapViewQueryLeakPipeXtd.h
//  AFNetworking
//
//  Created by 童万华 on 2019/7/4.
/*
 *“爆管分析”功能说明：
 1.  业务场景：有管段出现爆管险情，必须进行停水作业抢修，需要搜索具有关断特性的管点（如阀门等）。
 2. 功能操作逻辑：这种业务场景下，首先指定管段（可多选），进而搜索的结果既包含需要关闭的“具有关断特性的管点（如阀门等）”，又包含由此造成停水影响的用户、管段、管点等等信息。
 3. 用户需先点击“点选爆管点”按钮后在地图上选中好爆管点；
 可通过点击“清除爆管点”按钮清除地图上已选好的爆管点。注意：需要支持多爆管点选择。
*/

#import "Z3MapViewTapQueryXtd.h"

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewIdentityResult,AGSPolygon;
typedef void(^QueryPipeComplication)(Z3MapViewIdentityResult *result);
@interface Z3MapViewQueryLeakPipeXtd : Z3MapViewTapQueryXtd

- (void)registerQueryPipeComplication:(QueryPipeComplication)complication;
/**
 关阀搜索

 @param valveNods 二次关阀的阀门GID
 */
- (void)searchRelativeValves:(NSString * _Nullable)valveNods;
    
- (void)switchDisplayFeatues:(NSArray *)features closeArea:(AGSPolygon *)closeArea;
    
- (void)clearAnalyseResults;
@end

NS_ASSUME_NONNULL_END
