//
//  Z3MapViewSwitchOperationView.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/30.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewOperation;
@protocol Z3MapViewSwitchOperationViewDelegate <NSObject>
- (void)operationViewDidSelectedOperation:(Z3MapViewOperation *)operation;
@end
@interface Z3MapViewSwitchOperationView : UIView
@property (nonatomic,copy) NSArray *dataSource;
@property (nonatomic,weak) id<Z3MapViewSwitchOperationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
