//
//  Z3MapViewOperationDelegate.h
//  Z3MapView
//
//  Created by 童万华 on 2019/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapViewOperation;
@protocol Z3MapViewOperationDelegate <NSObject>
@optional
- (void)layerFilterView:(UIView *)filterView didChangeLayerStateAtIndex:(NSUInteger)index layerDisplayState:(BOOL)isDisplay;

- (void)mapOperationView:(UIView *)operationView didSelectedOperation:(Z3MapViewOperation *)operation;

@end

NS_ASSUME_NONNULL_END
