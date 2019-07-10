//
//  MapLayerFilterView.h
//  OutWork
//
//  Created by ZZHT on 2018/7/17.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Z3MapViewOperationDelegate.h"

@interface Z3MapViewLayerFilterView : UIView
- (instancetype)initWithLayerDataSource:(NSArray *)dataSource
                            andDelegate:(id<Z3MapViewOperationDelegate>)delegate;
@property (nonatomic,copy,readonly) NSArray *layerDataSource;//图层信息
@end
