//
//  Z3MapViewMeasureXtd.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewCommandXtd.h"

NS_ASSUME_NONNULL_BEGIN
@class AGSGraphicsOverlay;
@interface Z3MapViewMeasureXtd : Z3MapViewCommandXtd
@property (nonatomic,strong,readonly) AGSGraphicsOverlay *sketchGraphicsOverlay;
@end

NS_ASSUME_NONNULL_END
