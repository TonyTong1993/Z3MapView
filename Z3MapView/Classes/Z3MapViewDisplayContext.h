//
//  Z3MapViewDisplayContext.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/18.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSMapView,AGSEnvelope,AGSPoint;
typedef void(^MapViewLoadStatusListener)(NSInteger status);

@interface Z3MapViewDisplayContext : NSObject
@property (nonatomic,weak,readonly) AGSMapView *mapView;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithAGSMapView:(AGSMapView *)mapView;

//设置map layer load status
- (void)setMapViewLoadStatusListener:(MapViewLoadStatusListener)listener;

//设置mapView viewpoint
- (void)zoomIn;
- (void)zoomOut;
- (void)zoomToEnvelope:(AGSEnvelope *)envelop;
- (void)zoomToPoint:(AGSPoint *)point withScale:(double)scale;
- (void)zoomToInitialEnvelop;
@end

NS_ASSUME_NONNULL_END
