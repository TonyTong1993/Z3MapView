//
//  Z3MapViewCommon.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import <PromiseKit.h>
NS_ASSUME_NONNULL_BEGIN
@class AGSMapView,UIViewController;
typedef void(^OnComplicationBlock)(void);
@interface Z3MapViewCommandXtd : NSObject
@property (nonatomic,weak,readonly) UIViewController *targetViewController;
@property (nonatomic,weak,readonly) AGSMapView *mapView;
@property (nonatomic,copy,readonly) OnComplicationBlock complication;
@property (nonatomic,copy) NSDictionary *userInfo;

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController mapView:(AGSMapView *)mapView NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/**
 移除所有的graphics
 */
- (void)removeAllGraphics;
- (void)setOnComplicationListener:(OnComplicationBlock)conmplication;
- (void)post:(NSNotificationName)notificationName message:(id _Nullable)message;
- (void)updateLocaion:(AGSLocation * _Nonnull)location;
@end

NS_ASSUME_NONNULL_END
