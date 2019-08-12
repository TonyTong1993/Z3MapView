//
//  Z3CalloutViewDelegate.h
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewIdentityResult;
@protocol Z3CalloutViewDelegate <NSObject>
- (void)setIdentityResult:(Z3MapViewIdentityResult *)result;
@end

NS_ASSUME_NONNULL_END
