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
@property (nonatomic,copy) MakeRectComplication makeRectComplication;
@property (nonatomic,assign) NSInteger type;
@end
@implementation Z3MapViewRectQueryXtd

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController mapView:(AGSMapView *)mapView {
    self = [super initWithTargetViewController:targetViewController mapView:mapView];
    if (self) {
        _mpoints = [NSMutableArray arrayWithCapacity:2];
        _active = YES;
    }
    return self;
}


- (void)setUserInfo:(NSDictionary *)userInfo {
    [super setUserInfo:userInfo];
    if ([userInfo.allKeys containsObject:@"type"]) {
       _type = [userInfo[@"type"] intValue];
    }
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

- (void)clear {
    [super clear];
    [self dissmissGraphicsForQuery];
    [self.identityContext resume];
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

- (void)registerQueryComplcation:(void (^)(NSArray * results,NSDictionary *geometry, NSError * error))complcation {
    self.handler = complcation;
}

- (void)registerMakeRectComplcation:(MakeRectComplication)complcation {
    self.makeRectComplication = complcation;
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    if (self.mpoints.count == 1) {
        [self.mpoints addObject:mapPoint];
        AGSGeometry *geometry =  [[[AGSPolylineBuilder alloc] initWithPoints:[self.mpoints copy]] toGeometry];
        AGSEnvelope *envelop = [geometry extent];
        [self displayPointGraphicWithGeometry:mapPoint];
        [self displayEnvelopGraphicWithGeometry:envelop];
        if (!envelop.isEmpty && self.makeRectComplication) {
            NSError * __autoreleasing error = nil;
            NSDictionary *json = [envelop toJSON:&error];
            self.makeRectComplication(json, error);
        }
        if (!self.active) {
            return nil;
        }
        return envelop;
    }else if (self.mpoints.count == 0) {
        [self.mpoints addObject:mapPoint];
        [self displayPointGraphicWithGeometry:mapPoint];
    }
    return nil;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context
                           mapPoint:mapPoint
                    identityResults:(nonnull NSArray *)results
                        displayType:(NSInteger)displayType{
    [super identityContextQuerySuccess:context mapPoint:mapPoint identityResults:results displayType:_type];

}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    [self dissmissGraphicsForQuery];
    NSErrorDomain domain = @"mapView.identity.failure";
    NSInteger errorCode = 444;
    NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
    if (self.handler) {
        self.handler(nil,nil,error);
    }
}


- (void)identityGraphicSuccess:(AGSGraphic *)graphic mapPoint:(AGSPoint *)mapPoint displayType:(NSInteger)displayType {
    [super identityGraphicSuccess:graphic mapPoint:mapPoint displayType:_type];
}

- (void)identityGraphicFailure {
    [self.mapView.callout dismiss];
}



@end


