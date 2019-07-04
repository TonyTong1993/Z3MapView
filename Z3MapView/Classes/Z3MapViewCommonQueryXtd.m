//
//  Z3MapViewCommonQueryXtd.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewCommonQueryXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3GraphicFactory.h"
#import "Z3MapViewPrivate.h"
#import <UIDevice+YYAdd.h>
@interface Z3MapViewCommonQueryXtd()
@property (nonatomic,strong) NSArray *buttons;
@end
@implementation Z3MapViewCommonQueryXtd
@synthesize identityContext = _identityContext;
- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController mapView:(AGSMapView *)mapView {
    self = [super initWithTargetViewController:targetViewController mapView:mapView];
    if (self) {
        _identityContext = [[Z3MapViewIdentityContext alloc] initWithAGSMapView:mapView];
        _identityContext.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    [self dismiss];
    _identityContext = nil;
}

- (void)display {
    [super display];
}

- (void)dismiss {
    [super dismiss];
    [_identityContext dissmiss];
    if (![UIDevice currentDevice].isPad) {
        [[self.mapView subviews] setValue:@(NO) forKey:NSStringFromSelector(@selector(hidden))];
        [self.targetViewController.tabBarController.tabBar setHidden:NO];
    }
    
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    
    return (AGSGeometry *)mapPoint;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context {
    if (![UIDevice currentDevice].isPad) {
        [[self.mapView subviews] setValue:@(YES) forKey:NSStringFromSelector(@selector(hidden))];
        [self.targetViewController.tabBarController.tabBar setHidden:YES];
        [self.mapView setNeedsUpdateConstraints];
    }else {
        
    }
    
    
}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    
}

- (AGSGraphicsOverlay *)queryGraphicsOverlay {
    AGSGraphicsOverlay *result = nil;
    for (AGSGraphicsOverlay *overlay in self.mapView.graphicsOverlays) {
        if ([overlay.overlayID isEqualToString:IDENTITY_GRAPHICS_OVERLAY_ID]) {
            result = overlay;
            break;
        }
    }
    NSAssert(result, @"query.graphics.overlay did not create");
    return result;
}

@end
