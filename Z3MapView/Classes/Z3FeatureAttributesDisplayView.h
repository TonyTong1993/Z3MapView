//
//  Z3FeatureAttributesDisplayView.h
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewIdentityResult,AGSArcGISFeature;
@interface Z3FeatureAttributesDisplayView : UIView
@property (nonatomic,strong,readonly) Z3MapViewIdentityResult *result;
- (void)setIdentityResult:(Z3MapViewIdentityResult *)result;
- (void)setFeature:(AGSArcGISFeature *)feature;
@end

NS_ASSUME_NONNULL_END
