//
//  Z3MapViewCommon.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSMapView;
typedef void(^OnComplicationBlock)(void);
@interface Z3MapViewCommonXtd : NSObject
@property (nonatomic,weak,readonly) UIViewController *targetViewController;
@property (nonatomic,weak,readonly) AGSMapView *mapView;
@property (nonatomic,copy,readonly) OnComplicationBlock listener;

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController mapView:(AGSMapView *)mapView NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (void)setOnComplicationListener:(OnComplicationBlock)conmplication;
@end

NS_ASSUME_NONNULL_END
