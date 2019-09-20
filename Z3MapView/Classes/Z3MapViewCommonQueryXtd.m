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
@synthesize identityContext = _identityContext,queryGraphicsOverlay = _queryGraphicsOverlay;
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
    _displayIdentityResultContext = nil;
    _identityContext = nil;
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
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) {
        [[self.mapView subviews] setValue:@(NO) forKey:NSStringFromSelector(@selector(hidden))];
        [self.targetViewController.tabBarController.tabBar setHidden:NO];
    }
    [self.mapView.callout setCustomView:nil];
}

- (void)clear {
    [_identityContext clear];
    [self.displayIdentityResultContext dismiss];
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

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context
                           mapPoint:mapPoint
                    identityResults:(nonnull NSArray *)results {
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) {
        if (self.targetViewController.tabBarController) {
            [[self.mapView subviews] setValue:@(YES) forKey:NSStringFromSelector(@selector(hidden))];
            [self.targetViewController.tabBarController.tabBar setHidden:YES];
            [self.mapView setNeedsUpdateConstraints];
        }
    }
    
    if (self.displayIdentityResultContext == nil) {
        self.displayIdentityResultContext = [[Z3MapViewDisplayIdentityResultContext alloc] initWithAGSMapView:self.mapView];
        self.displayIdentityResultContext.delegate = self;
        [self.displayIdentityResultContext setShowPopup:YES];
    }
   
    if (self.handler) {
        self.handler(results,context.queryGeometry,nil);
    }
    
    [self.displayIdentityResultContext updateIdentityResults:results mapPoint:mapPoint];
    
}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    if (self.handler) {
        NSErrorDomain domain = @"mapView.identity.failure";
        NSInteger errorCode = 444;
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        self.handler(nil,context.queryGeometry,error);
    }
}

- (void)identityGraphicSuccess:(AGSGraphic *)graphic mapPoint:(AGSPoint *)mapPoint {
     [self.displayIdentityResultContext setSelectedIdentityGraphic:graphic mapPoint:mapPoint];
}

- (void)identityGraphicFailure {
    [self clear];
}

- (void)queryWithGeometry:(AGSGeometry *)geometry arguments:(NSDictionary *)arguments complcation:(nonnull void (^)(NSArray * _Nullable,NSDictionary *geometry,NSError * _Nullable))complcation {
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
    if (_queryGraphicsOverlay == nil) {
        for (AGSGraphicsOverlay *overlay in self.mapView.graphicsOverlays) {
            if ([overlay.overlayID isEqualToString:QUERY_GRAPHICS_OVERLAY_ID]) {
                _queryGraphicsOverlay = overlay;
                break;
            }
        }
        NSAssert(_queryGraphicsOverlay, @"query.graphics.overlay did not create");
    }
    return _queryGraphicsOverlay;
}

@end
