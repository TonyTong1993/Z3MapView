//
//  Z3MapViewRectQueryXtd.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewRectQueryXtd.h"
#import "Z3MapViewPrivate.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3GraphicFactory.h"
@interface Z3MapViewRectQueryXtd ()
@property (nonatomic,strong) NSMutableArray *mpoints;
@end
@implementation Z3MapViewRectQueryXtd

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController mapView:(AGSMapView *)mapView {
    self = [super initWithTargetViewController:targetViewController mapView:mapView];
    if (self) {
        _mpoints = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

- (void)displayPointGraphicWithGeometry:(AGSPoint *)geometry {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildSimpleMarkGraphicWithPoint:geometry attributes:nil];
    [self.queryGraphicsOverlay.graphics addObject:graphic];
    [graphic setSelected:YES];
}

- (void)displayEnvelopGraphicWithGeometry:(AGSGeometry *)geometry {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildSimpleEnvelopGraphicWithEnvelop:(AGSEnvelope *)geometry  attributes:nil];
    [self.queryGraphicsOverlay.graphics addObject:graphic];
    [graphic setSelected:YES];
}

- (void)dissmissGraphicsForQuery {
    if (self.queryGraphicsOverlay) {
        [self.queryGraphicsOverlay.graphics removeAllObjects];
        [self.mpoints removeAllObjects];
    }
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    if (self.mpoints.count == 1) {
        [self.mpoints addObject:mapPoint];
        AGSGeometry *geometry =  [[[AGSPolylineBuilder alloc] initWithPoints:[self.mpoints copy]] toGeometry];
        AGSEnvelope *envelop = [geometry extent];
        [self displayPointGraphicWithGeometry:mapPoint];
        [self displayEnvelopGraphicWithGeometry:envelop];
        return envelop;
    }else if (self.mpoints.count == 0) {
        [self.mpoints addObject:mapPoint];
        [self displayPointGraphicWithGeometry:mapPoint];
    }
    return nil;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context identityResults:(nonnull NSArray *)results{
    [super identityContextQuerySuccess:context identityResults:results];
    [self dissmissGraphicsForQuery];
}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    [self dissmissGraphicsForQuery];
}
@end
