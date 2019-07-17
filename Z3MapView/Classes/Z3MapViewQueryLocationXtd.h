//
//  Z3MapViewQueryLocationXtd.h
//  OutWork
//
//  Created by 童万华 on 2019/7/11.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import "Z3MapViewCommonXtd.h"
NS_ASSUME_NONNULL_BEGIN
@interface Z3MapViewQueryLocationXtd : Z3MapViewCommonXtd

@end

extern NSNotificationName const Z3MapViewQueryLocationComplicationNotification;//通知位置发生改变通知名
extern NSString * const Z3MapViewQueryLocationKey;//获取位置的key userInfo
extern NSString * const Z3MapViewQueryAddressKey;//获取address key userInfo

NS_ASSUME_NONNULL_END
