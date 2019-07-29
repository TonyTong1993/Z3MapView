//
//  Z3MapViewPrivate.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Z3MapViewCommonXtd.h"
#import "Z3MapViewMeasureXtd.h"
#import <ArcGIS/AGSEnumerations.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^ComplicationHander)(NSArray * _Nullable results,NSError * _Nullable error);
extern NSString * const IDENTITY_GRAPHICS_OVERLAY_ID;
extern NSString * const QUERY_GRAPHICS_OVERLAY_ID;
extern NSString * const TRACK_GRAPHICS_OVERLAY_ID;
@interface Z3MapViewCommonXtd (Private)
- (void)display;
- (void)dismiss;
- (void)updateNavigationBar;
- (void)rollbackNavgationBar;
- (void)clearSubViewsInMapView;
@end
@class AGSSketchStyle,AGSSketchEditConfiguration;
@interface Z3MapViewMeasureXtd (Private)
- (AGSSketchCreationMode)creationMode;
- (AGSSketchStyle *)style;
- (AGSSketchEditConfiguration *)sketchEditConfiguration;
- (void)onListenerGeometryDidChange:(NSNotification *)notification;
@end
NS_ASSUME_NONNULL_END
