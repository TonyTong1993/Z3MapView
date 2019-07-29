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
#import <YYKit/YYKit.h>
#import "Z3QueryTaskHelper.h"
#import "Z3MobileTask.h"
@interface Z3MapViewCommonQueryXtd()
@property (nonatomic,strong) NSArray *buttons;
@property (nonatomic,copy) ComplicationHander handler;
@end
@implementation Z3MapViewCommonQueryXtd
@synthesize identityContext = _identityContext;
- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController mapView:(AGSMapView *)mapView {
    self = [super initWithTargetViewController:targetViewController mapView:mapView];
    if (self) {
        _identityContext = [[Z3MapViewIdentityContext alloc] initWithAGSMapView:mapView];
        _identityContext.delegate = self;
        Z3MobileTask *task = [[Z3QueryTaskHelper helper] queryTaskWithName:SPACIAL_SEARCH_URL_TASK_NAME];
        NSString *identityURL = [task.baseURL stringByAppendingPathComponent:@"identify"];
        [_identityContext setIdentityURL:identityURL];
       
    }
    
    return self;
}

- (void)dealloc {
    _identityContext = nil;
}

- (void)display {
    [super display];
}

- (void)updateNavigationBar {
    [super updateNavigationBar];
    UIImage *cleanImage = [UIImage imageNamed:@"nav_clear"];
    UIBarButtonItem *cleanItem = [[UIBarButtonItem alloc] initWithImage:cleanImage style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    self.targetViewController.navigationItem.rightBarButtonItem = cleanItem;
}

- (void)dismiss {
    [super dismiss];
    [_identityContext dissmiss];
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        [[self.mapView subviews] setValue:@(NO) forKey:NSStringFromSelector(@selector(hidden))];
        [self.targetViewController.tabBarController.tabBar setHidden:NO];
    }
}

- (void)clear {
    [_identityContext clear];
    
}

- (void)setIdentityUserInfo:(NSDictionary *)userInfo {
    self.userInfo = userInfo;
}

- (void)setIdentityMode:(Z3MapViewIdentityContextMode)mode {
    [self.identityContext setMode:mode];
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    
    return (AGSGeometry *)mapPoint;
}

- (NSDictionary *)userInfoForIdentityContext:(Z3MapViewIdentityContext *)context {
    return self.userInfo;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context identityResults:(nonnull NSArray *)results {
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) {
        if (self.targetViewController.tabBarController) {
            [[self.mapView subviews] setValue:@(YES) forKey:NSStringFromSelector(@selector(hidden))];
            [self.targetViewController.tabBarController.tabBar setHidden:YES];
            [self.mapView setNeedsUpdateConstraints];
        }
    }
    
    if (self.handler) {
        self.handler(results, nil);
    }
    
}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    if (self.handler) {
        NSErrorDomain domain = @"mapView.identity.failure";
        NSInteger errorCode = 444;
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        self.handler(nil, error);
    }
}

- (void)queryWithGeometry:(AGSGeometry *)geometry arguments:(NSDictionary *)arguments complcation:(nonnull void (^)(NSArray * _Nullable, NSError * _Nullable))complcation {
    self.handler =  complcation;
    Z3MobileTask *task = [[Z3QueryTaskHelper helper] queryTaskWithName:SPACIAL_SEARCH_URL_TASK_NAME];
    NSNumber *layerId = arguments[@"layers"];
    NSString *layerStr = [layerId stringValue];
    NSString *layerPath = [task.baseURL stringByAppendingPathComponent:layerStr];
    NSString *identityURL = [layerPath stringByAppendingPathComponent:@"query"];
    [_identityContext setIdentityURL:identityURL];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:arguments];
    [userInfo removeObjectForKey:@"layers"];
    [self.identityContext queryFeaturesWithGeometry:geometry userInfo:userInfo];
    
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
