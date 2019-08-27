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
#import "Z3HUDPipeLeakCalloutView.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3MapView.h"
#import "Z3GISMetaBuilder.h"
#import "Z3MobileConfig.h"
#import "Z3MobileTask.h"
#import "Z3QueryTaskHelper.h"
@interface Z3MapViewQueryLeakPipeXtd()
@property (nonatomic,strong) AGSPoint *tapPoint;//点击触发的位置

@property (nonatomic,strong) AGSPoint *tapLocation;//管段上距离触发点最近的点
@property (nonatomic,strong) NSDictionary *attributes;//管段上的属性
@end
@implementation Z3MapViewQueryLeakPipeXtd

- (UIView<Z3CalloutViewDelegate> *)calloutViewForDisplayIdentityResultInMapView {
    return [[Z3HUDPipeLeakCalloutView alloc] init];
}

- (AGSPoint *)tapLocationForDisplayCalloutView {
    return self.tapLocation;
}

- (AGSGraphic *)pointGraphicForDisplayIdentityResultInMapViewWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary *)attributes {
   return [[Z3GraphicFactory factory] buildPipeLeakValvesMarkGraphicWithPoint:geometry attributes:attributes];
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint {
    self.tapPoint = mapPoint;
   return [super identityContext:context didTapAtScreenPoint:screenPoint mapPoint:mapPoint];
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context identityResults:(nonnull NSArray *)results {
    //过滤爆管点
    __block double tmpDistance = 100000000000;
    __block Z3MapViewIdentityResult *reslut = nil;
    __block AGSPoint *tapLocation = nil;
    [results enumerateObjectsUsingBlock:^(Z3MapViewIdentityResult *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.geometryType isEqualToString:@"esriGeometryPolyline"]) {
            AGSPolyline *line = (AGSPolyline *)[obj geometry];
           AGSProximityResult *proximityResult  = [AGSGeometryEngine nearestCoordinateInGeometry:line toPoint:self.tapPoint];
           AGSPoint  *temPoint = proximityResult.point;
           double distance = [AGSGeometryEngine distanceBetweenGeometry1:temPoint geometry2:self.tapPoint];
            if (distance < tmpDistance) {
                tmpDistance = distance;
                reslut = obj;
                tapLocation = temPoint;
            }
        }
    }];
    self.tapLocation = tapLocation;
    self.attributes = reslut.attributes;
    [super identityContextQuerySuccess:context identityResults:@[reslut]];
    [self displayPipeLeakGraphicWithGeometry:tapLocation];
    [self post:Z3MapViewQueryLeakPipeXtdSelectedIssueLocationNotification message:reslut];
    
}

- (void)identityContextPipeAnaylseSuccess:(Z3MapViewIdentityContext *)context
                        pipeAnaylseResult:(Z3MapViewPipeAnaylseResult *)result {
    //将数据显示到图层上
    [self.displayIdentityResultContext updatePipeAnalyseResult:result];
    [self post:Z3MapViewQueryLeakPipeXtdAnaylseSuccessNotification message:result];
}

- (void)identityContextPipeAnaylseFailure:(Z3MapViewIdentityContext *)context {
    
}

- (void)identityGraphicFailure {
    [self.displayIdentityResultContext setSelectedIdentityGraphic:nil];
    [self.mapView.callout dismiss];
}

- (void)searchRelativeValves:(NSString *)valveNods {
    NSString *layerID = [[Z3GISMetaBuilder builder] pipeLayerID];
    NSString *objectId = self.attributes[@"gid"];
    NSDictionary *arguments = @{
                                @"layerId":layerID,
                                @"objectId":objectId,
                                @"valveNods":valveNods?:@""
                                };
    
    Z3MobileTask *task = [[Z3QueryTaskHelper helper] queryTaskWithName:SPACIAL_SEARCH_URL_TASK_NAME];
    NSString *identityURL = [task.baseURL stringByAppendingPathComponent:@"PipeAnalyse/accident"];
    [self.identityContext pipeAnalyseFeatureWithGisServer:identityURL geometry:self.tapLocation userInfo:arguments];

}

- (void)displayPipeLeakGraphicWithGeometry:(AGSPoint *)geometry {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildPipeLeakMarkGraphicWithPoint:geometry attributes:nil];
    graphic.zIndex = 2;
    [self.queryGraphicsOverlay.graphics addObject:graphic];
    [graphic setSelected:YES];
    
}

- (void)dismiss {
    [super dismiss];
    [self dissmissPipeLeakGraphic];
    [self post:Z3MapViewQueryLeakPipeXtdDeselectIssueLocationNotification message:nil];
}

- (void)dissmissPipeLeakGraphic {
    if (self.queryGraphicsOverlay) {
        [self.queryGraphicsOverlay.graphics removeAllObjects];
    }
}


@end
