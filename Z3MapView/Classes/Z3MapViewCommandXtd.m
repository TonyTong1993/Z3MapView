//
//  Z3MapViewCommon.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewCommandXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import <YYKit/YYKit.h>
@interface Z3MapViewCommandXtd ()
@property (nonatomic,strong) NSArray *rightItems;
@end
@implementation Z3MapViewCommandXtd

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
    if (!self.targetViewController.navigationController.isNavigationBarHidden) {
        [self rollbackNavgationBar];
    }
    [self dismiss];
}

- (void)display {
    if (!self.targetViewController.navigationController.isNavigationBarHidden) {
        [self updateNavigationBar];
    }
}

- (void)setOnComplicationListener:(OnComplicationBlock)complication {
    _complication = complication;
}

//修改导航栏样式
- (void)updateNavigationBar {
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        UIBarButtonItem *lefttem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
        self.targetViewController.navigationItem.leftBarButtonItem = lefttem;
        self.rightItems = self.targetViewController.navigationItem.rightBarButtonItems;
        self.targetViewController.navigationItem.rightBarButtonItems = nil;
        [self.targetViewController.tabBarController.tabBar setHidden:YES];
    }
}

- (void)dismiss {
    if (self.complication) {
        self.complication();
    }else {
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) {
            NSArray *childViewControllers = [self.targetViewController.navigationController childViewControllers];
            NSUInteger index = [childViewControllers indexOfObject:self.targetViewController];
            if (index > 0) {
                [self.targetViewController.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

//还原导航栏样式
- (void)rollbackNavgationBar {
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        self.targetViewController.navigationItem.leftBarButtonItem = nil;
        self.targetViewController.navigationItem.rightBarButtonItems = self.rightItems;
        [self.targetViewController.tabBarController.tabBar setHidden:NO];
        [self.mapView.callout dismiss];
        [self.mapView.callout setCustomView:nil];
    }
}

- (void)clearSubViewsInMapView{
    NSArray *subViews = [self.mapView subviews];
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
}

- (void)post:(NSNotificationName)notificationName message:(id)message {
    if (message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:@{@"message":message}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }
}

- (void)removeAllGraphics {
    
}


- (void)updateLocaion:(AGSLocation * _Nonnull)location{
    
}

@end

