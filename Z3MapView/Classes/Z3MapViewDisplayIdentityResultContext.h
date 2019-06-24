//
//  Z3MapViewDisplayIdentityResultContext.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewDisplayIdentityResultContext,Z3MapViewIdentityResult;
@protocol Z3MapViewDisplayIdentityResultContextDelegate <NSObject>



@end


@class AGSMapView,AGSGraphic;
@interface Z3MapViewDisplayIdentityResultContext : NSObject
@property (nonatomic,weak,readonly) AGSMapView *mapView;
@property (nonatomic,weak,readonly) AGSGraphic *selectedGraphic;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView identityResults:(NSArray *)results;
- (void)updateIdentityResults:(NSArray *)results;
- (void)setSelectedIdentityGraphic:(AGSGraphic *)graphic;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
