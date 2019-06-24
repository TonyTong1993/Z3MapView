//
//  Z3AGSPopupFactory.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewIdentityResult,AGSGraphic,AGSPopup;
@interface Z3AGSPopupFactory : NSObject
+ (instancetype)factory;

/**
 构建一个popup 数据源

 @param result 元数据
 @param graphic 元数据相对应的graphic
 @return popup
 */
- (AGSPopup *)buildPopupWithIdentityResult:(Z3MapViewIdentityResult *)result
                                   graphic:(AGSGraphic *)graphic;


/**
 构建多个popup 数据源

 @param results 元数据集合
 @param graphics 元数据集合对应的graphics
 @return popups
 */
- (NSArray *)buildPopupsWithIdentityResults:(NSArray *)results
                                   graphics:(NSArray *)graphics;
@end

NS_ASSUME_NONNULL_END
