//
//  Z3MapViewPipeAnalyseResponse.h
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Z3MapViewQueryInflenceUsersResponse : Z3BaseResponse
@property (nonatomic,assign) BOOL isEmpty;
@end

@interface Z3MapViewPipeAnalyseResponse : Z3BaseResponse
@property (nonatomic,assign) BOOL isEmpty;
- (NSString *)mainWhere;
- (void)refreshRespone:(Z3MapViewQueryInflenceUsersResponse *)response;
@end





NS_ASSUME_NONNULL_END
