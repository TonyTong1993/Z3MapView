//
//  Z3DisplayIdentityResultViewCell.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewIdentityResult;
@interface Z3DisplayIdentityResultViewCell : UICollectionViewCell
@property (strong, nonatomic)  UILabel *deviceLabel;
- (void)setIdentityResult:(Z3MapViewIdentityResult *)result
              displayType:(NSInteger)displayType;
//隐藏底部按钮
- (void)setButtonHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
