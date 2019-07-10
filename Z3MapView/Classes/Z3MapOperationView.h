//
//  mapOperationView.h
//  OutWork
//
//  Created by ZZHT on 2018/7/17.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Z3MapViewOperationDelegate.h"
@class Z3MapViewOperation;

@interface Z3MapOperationView : UIView
- (instancetype)initWithOperationItems:(NSArray *)items
                          withDelegate:(id<Z3MapViewOperationDelegate>)delegate;
@property (nonatomic,copy,readonly) NSArray *items;
@end
