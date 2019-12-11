//
//  Z3DisplayIdentityResultView.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol Z3DisplayIdentityResultViewDelegate <NSObject>
- (void)displayIdentityViewDidScrollToPageIndex:(NSUInteger)index;
@end
@interface Z3DisplayIdentityResultView : UIView
@property (nonatomic,weak) id<Z3DisplayIdentityResultViewDelegate> delegate;
- (instancetype)initWithDataSource:(NSArray *)dataSource;
- (void)setDataSource:(NSArray *)dataSource;
- (void)setSelectItem:(NSUInteger)index;
- (void)setDisplayType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
