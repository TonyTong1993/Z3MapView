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
    if (self.queryGraphicsOverlay) {
        [self.mapView.graphicsOverlays removeObject:self.queryGraphicsOverlay];
    }
}

- (void)display {
    
}

- (void)dismiss {
    [_identityContext dissmiss];
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
   
    return (AGSGeometry *)mapPoint;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context {
    
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
