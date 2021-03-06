//
//  Z3CalloutViewDelegate.h
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewIdentityResult,AGSArcGISFeature;
@protocol Z3CalloutViewDelegate <NSObject>
@optional
- (void)setIdentityResult:(AGSArcGISFeature *)result;
- (void)setFeature:(AGSArcGISFeature *)featrue;
@end

NS_ASSUME_NONNULL_END
