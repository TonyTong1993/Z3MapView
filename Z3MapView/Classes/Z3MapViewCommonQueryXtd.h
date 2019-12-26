//
//  Z3MapViewCommonQueryXtd.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewCommandXtd.h"
#import "Z3MapViewIdentityContext.h"
#import "Z3MapViewDisplayIdentityResultContext.h"
NS_ASSUME_NONNULL_BEGIN
@class AGSGraphicsOverlay;
@interface Z3MapViewCommonQueryXtd : Z3MapViewCommandXtd<Z3MapViewIdentityContextDelegate,Z3MapViewDisplayIdentityResultContextDelegate>
@property (nonatomic,strong,readonly) Z3MapViewIdentityContext *identityContext;
@property (nonatomic,strong,readonly) AGSGraphicsOverlay *queryGraphicsOverlay;
@property (nonatomic,readonly,strong) Z3MapViewDisplayIdentityResultContext *displayIdentityResultContext;

/**
 查询地理信息数据

 @param geometry 地理信息
 @param arguments 参数
 @param complcation 结果回调
 */
- (void)queryWithGeometry:(AGSGeometry * _Nullable)geometry
                    arguments:(NSDictionary *)arguments
                 complcation:(void (^)(NSArray * _Nullable results,NSDictionary *geometry,NSError * _Nullable error))complcation;

- (void)setIdentityMode:(Z3MapViewIdentityContextMode)mode;
- (void)setIdentityUserInfo:(NSDictionary *)userInfo;
//结束查询操作
- (void)dismiss;

    /// 点击右侧的清理按钮
- (void)clear;
@end

NS_ASSUME_NONNULL_END
