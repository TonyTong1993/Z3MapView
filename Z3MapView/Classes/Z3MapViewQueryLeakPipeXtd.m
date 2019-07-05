//
//  Z3MapViewQueryLeakPipeXtd.m
//  AFNetworking
//
//  Created by 童万华 on 2019/7/4.
//

#import "Z3MapViewQueryLeakPipeXtd.h"
#import "Z3MapViewPrivate.h"
#import "Z3MapViewIdentityContext.h"
#import "Z3GraphicFactory.h"
#import <ArcGIS/ArcGIS.h>
@implementation Z3MapViewQueryLeakPipeXtd

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController mapView:(AGSMapView *)mapView {
    self = [super initWithTargetViewController:targetViewController mapView:mapView];
    if (self) {
       [self.identityContext setDisplayPopup:NO];
    }
    return self;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context identityResults:(nonnull NSArray *)results {
    [super identityContextQuerySuccess:context identityResults:results];
    
}

@end
