//
//  Z3MapViewTapQueryXtd.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewTapQueryXtd.h"
#import "Z3MapViewPrivate.h"
#import "Z3MapViewIdentityContext.h"
#import "Z3GraphicFactory.h"
#import <ArcGIS/ArcGIS.h>

@implementation Z3MapViewTapQueryXtd
- (void)displayGraphicWithGeometry:(AGSPoint *)geometry {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildSimpleMarkGraphicWithPoint:geometry attributes:nil];
    [self.queryGraphicsOverlay.graphics addObject:graphic];
    [graphic setSelected:YES];
}

- (void)dismiss {
    [super dismiss];
    [self dissmissGraphicsForQuery];
}

- (void)dissmissGraphicsForQuery {
    if (self.queryGraphicsOverlay) {
        [self.queryGraphicsOverlay.graphics removeAllObjects];
    }
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    [self displayGraphicWithGeometry:mapPoint];
    return (AGSGeometry *)mapPoint;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context identityResults:(nonnull NSArray *)results {
    [super identityContextQuerySuccess:context identityResults:results];
    [self dissmissGraphicsForQuery];
}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    [self dissmissGraphicsForQuery];
}

@end
