//
//  Z3MapViewPOIDisplayContext.h
//  AMP
//
//  Created by ZZHT on 2019/8/8.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSMapView;
@interface Z3MapViewPOIDisplayContext : NSObject
@property (nonatomic,weak,readonly) AGSMapView *mapView;
@property (nonatomic,copy,readonly) NSArray *pois;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView;

/**
 POI相关
 */
- (void)showPOIs:(NSArray *)POIs;

/**
 选中POI

 @param indexPath 选中POI graphic 的位置
 */
- (void)setSelectPOIAtIndexPath:(NSIndexPath *)indexPath;


/// 设置选中POI
/// @param index 选中的位置
- (void)setSelectPOIAtIndex:(NSUInteger)index;

/**
 移除POI graphics
 */
- (void)dismissPOIs;
@end

NS_ASSUME_NONNULL_END
