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

- (void)display {
    
}

@end

@implementation Z3MapViewCommonXtd(Private)

-(void)display {
    
}

@end
