//
//  Z3MapViewCommonQueryXtd.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewCommonXtd.h"
#import "Z3MapViewIdentityContext.h"
NS_ASSUME_NONNULL_BEGIN
@class AGSGraphicsOverlay;
@interface Z3MapViewCommonQueryXtd : Z3MapViewCommonXtd<Z3MapViewIdentityContextDelegate>
@property (nonatomic,strong,readonly) Z3MapViewIdentityContext *identityContext;
@property (nonatomic,strong,readonly) AGSGraphicsOverlay *queryGraphicsOverlay;

//隐藏查询结果
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
