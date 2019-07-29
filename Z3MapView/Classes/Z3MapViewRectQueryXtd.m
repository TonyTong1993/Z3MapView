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
#import "Z3QueryTaskHelper.h"
#import "Z3MobileTask.h"
@interface Z3MapViewRectQueryXtd ()
@property (nonatomic,strong) NSMutableArray *mpoints;
@property (nonatomic,copy) ComplicationHander handler;
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

- (void)dismiss {
    [super dismiss];
    [self dissmissGraphicsForQuery];
}

- (void)dissmissGraphicsForQuery {
    if (self.queryGraphicsOverlay) {
        [self.queryGraphicsOverlay.graphics removeAllObjects];
        [self.mpoints removeAllObjects];
    }
}

- (void)setArguments:(NSDictionary *)arguments {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:arguments];
    [userInfo removeObjectForKey:@"layers"];
    self.userInfo = userInfo;
    Z3MobileTask *task = [[Z3QueryTaskHelper helper] queryTaskWithName:SPACIAL_SEARCH_URL_TASK_NAME];
    NSNumber *layerId = arguments[@"layers"];
    NSString *layerStr = [layerId stringValue];
    NSString *layerPath = [task.baseURL stringByAppendingPathComponent:layerStr];
    NSString *identityURL = [layerPath stringByAppendingPathComponent:@"query"];
    [self.identityContext setIdentityURL:identityURL];
}

- (void)registerQueryComplcation:(void (^)(NSArray * results, NSError * error))complcation {
    self.handler = complcation;
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
    if (self.handler) {
        self.handler(results, nil);
    }
}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    [self dissmissGraphicsForQuery];
    NSErrorDomain domain = @"mapView.identity.failure";
    NSInteger errorCode = 444;
    NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
    if (self.handler) {
        self.handler(nil, error);
    }
}

@end
