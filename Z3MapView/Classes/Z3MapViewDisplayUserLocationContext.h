//
//  Z3MapViewDisplayUserLocationContext.h
//  OutWork
//
//  Created by ZZHT on 2019/7/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSMapView,AGSPoint;
@interface Z3MapViewDisplayUserLocationContext : NSObject
@property (nonatomic,weak,readonly) AGSMapView *mapView;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView;

/**
 是否显示用户轨迹
 
 @param show default NO
 */
- (void)showUserTrack:(BOOL)show;

/**
 更新用户位置

 @param point 当前位置
 */
- (void)updateLocation:(AGSPoint *)point;
@end

NS_ASSUME_NONNULL_END
