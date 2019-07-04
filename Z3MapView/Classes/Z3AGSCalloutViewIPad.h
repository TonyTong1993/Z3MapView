//
//  Z3AGSCalloutViewIPad.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/21.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewIdentityResult;
@interface Z3AGSCalloutViewIPad : UIView
+ (instancetype)calloutView;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (void)setIdentityAttributes:(NSDictionary *)attributes;
@end

NS_ASSUME_NONNULL_END
