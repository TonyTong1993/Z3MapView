//
//  Z3MapViewCommon.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewCommonXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import <YYKit/YYKit.h>
@interface Z3MapViewCommonXtd ()
@property (nonatomic,strong) NSArray *rightItems;
@end
@implementation Z3MapViewCommonXtd

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController mapView:(AGSMapView *)mapView {
    self = [super init];
    if (self) {
        _targetViewController = targetViewController;
        _mapView = mapView;
        [self display];
    }
    
    return self;
}

- (void)dealloc {
    [self rollbackNavgationBar];
}

- (void)display {
    [self updateNavigationBar];
}

- (void)setOnComplicationListener:(OnComplicationBlock)complication {
    _listener = complication;
}

//修改导航栏样式
- (void)updateNavigationBar {
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        UIBarButtonItem *lefttem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
        self.targetViewController.navigationItem.leftBarButtonItem = lefttem;
        self.rightItems = self.targetViewController.navigationItem.rightBarButtonItems;
        self.targetViewController.navigationItem.rightBarButtonItems = nil;
    }
}

- (void)dismiss {
    if (self.listener) {
        self.listener();
    }
}

//还原导航栏样式
- (void)rollbackNavgationBar {
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        self.targetViewController.navigationItem.leftBarButtonItem = nil;
        self.targetViewController.navigationItem.rightBarButtonItems = self.rightItems;
    }
}

- (void)clearSubViewsInMapView{
    NSArray *subViews = [self.mapView subviews];
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
}


@end

