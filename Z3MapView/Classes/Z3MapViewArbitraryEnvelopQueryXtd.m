//
//  Z3MapViewArbitraryEnvelopQueryXtd.m
//  AFNetworking
//
//  Created by 童万华 on 2019/7/4.
//范围查询

#import "Z3MapViewArbitraryEnvelopQueryXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import "Z3QueryTaskHelper.h"
#import "Z3MobileTask.h"
@implementation Z3MapViewArbitraryEnvelopQueryXtd
- (void)display {
    [super display];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onListenerGeometryDidChange:) name:AGSSketchEditorGeometryDidChangeNotification object:nil];
    [self measure];
}


- (void)dismiss {
    [super dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AGSSketchEditorGeometryDidChangeNotification object:nil];
    [self.mapView.sketchEditor stop];
    self.mapView.sketchEditor = nil;
}

- (void)updateNavigationBar {
    [super updateNavigationBar];
    
    NSMutableArray *rightItems = [NSMutableArray arrayWithCapacity:2];
    UIImage *cleanImage = [UIImage imageNamed:@"nav_clear"];
    UIBarButtonItem *cleanItem = [[UIBarButtonItem alloc] initWithImage:cleanImage style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [rightItems addObject:cleanItem];
    UIImage *seacherIcon = [UIImage imageNamed:@"btn_seacher_nor"];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:seacherIcon style:UIBarButtonItemStylePlain target:self action:@selector(queryByMakedEnvelop)];
    if (@available(iOS 11.0, *)) {
        searchItem.imageInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    [rightItems addObject:searchItem];
    self.targetViewController.navigationItem.rightBarButtonItems = rightItems;
}

- (void)measure{
    AGSSketchEditor *sketchEditor = [AGSSketchEditor sketchEditor];
    [self.mapView setSketchEditor:sketchEditor];
    [self.mapView.sketchEditor startWithCreationMode:[self creationMode] editConfiguration:[self sketchEditConfiguration]];
    
}

- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    
}

- (void)queryByMakedEnvelop {
    AGSPolygon *geometry = (AGSPolygon *)self.mapView.sketchEditor.geometry;
    double area = [AGSGeometryEngine geodeticAreaOfGeometry:geometry areaUnit:[AGSAreaUnit squareKilometers] curveType:AGSGeodeticCurveTypeShapePreserving];
    if (area > 0.0f) {
        Z3MobileTask *task = [[Z3QueryTaskHelper helper] queryTaskWithName:SPACIAL_SEARCH_URL_TASK_NAME];
        NSString *identityURL = [task.baseURL stringByAppendingPathComponent:@"identify"];
        AGSGeometry *geometry = [self.mapView.sketchEditor geometry];
        [self.identityContext identityFeaturesWithGisServer:identityURL geometry:geometry userInfo:nil];
    }
}

- (void)clear {
    [self.mapView.sketchEditor clearGeometry];
    if (![self.mapView.sketchEditor isStarted]) {
        [self.mapView.sketchEditor startWithCreationMode:[self creationMode]];
    }
    [self.identityContext dissmiss];
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context
                           mapPoint:mapPoint
                    identityResults:(NSArray *)results
                        displayType:(NSInteger)displayType {
    [super identityContextQuerySuccess:context mapPoint:mapPoint identityResults:results displayType:displayType];
    [self.mapView.sketchEditor stop];
}

- (void)identityContextQueryFailure:(Z3MapViewIdentityContext *)context {
    [self.mapView.sketchEditor clearGeometry];
}

- (AGSSketchEditConfiguration *)sketchEditConfiguration {
    AGSSketchEditConfiguration *configuration = [[AGSSketchEditConfiguration alloc] init];
    
    return configuration;
}

- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModePolygon;
}

- (AGSSketchStyle *)style {
    return nil;
}
@end
