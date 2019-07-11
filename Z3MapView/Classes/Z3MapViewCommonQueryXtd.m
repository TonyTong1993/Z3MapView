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

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    
    return (AGSGeometry *)mapPoint;
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context identityResults:(nonnull NSArray *)results {
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
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
