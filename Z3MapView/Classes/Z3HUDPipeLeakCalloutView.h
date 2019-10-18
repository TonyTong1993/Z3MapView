//
//  Z3HUDPipeLeakCalloutView.h
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Z3CalloutViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@protocol Z3HUDPipeLeakCalloutViewDelegate <NSObject>
- (void)calloutView:(UIView *)sender closeValve:(NSString *)valveId;
@end
@interface Z3HUDPipeLeakCalloutView : UIView<Z3CalloutViewDelegate>
@property (nonatomic,assign) BOOL closeValveable;
@property (nonatomic,weak) id<Z3HUDPipeLeakCalloutViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
