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
#import "Z3GISMetaQuery.h"
#import "Z3MobileConfig.h"
#import "Z3MobileTask.h"
#import "Z3QueryTaskHelper.h"
#import "MBProgressHUD.h"
@interface Z3MapViewQueryLeakPipeXtd()<Z3HUDPipeLeakCalloutViewDelegate>
@property (nonatomic,strong) AGSPoint *tapLocation;//管段上距离触发点最近的点
@property (nonatomic,strong) Z3MapViewIdentityResult *result;//管段
@property (nonatomic,copy) QueryPipeComplication queryPipeComplication;
@property (nonatomic,strong) NSMutableSet *mset;
@property (nonatomic,assign) NSUInteger type;
@end
@implementation Z3MapViewQueryLeakPipeXtd
static  CGFloat PipeLeakCalloutViewWidth = 100.0f;
static  CGFloat PipeLeakCalloutViewHeight = 32.0f;
- (UIView<Z3CalloutViewDelegate> *)calloutViewForDisplayIdentityResult:(Z3MapViewIdentityResult *)result {
    Z3HUDPipeLeakCalloutView *callout = [[Z3HUDPipeLeakCalloutView alloc] init];
    callout.closeValveable = YES;
    callout.delegate = self;
    CGSize size = CGSizeZero;
    NSString *layerId = [NSString stringWithFormat:@"%ld",result.layerId];
    if ([[Z3GISMetaQuery querier].valveLayerIDs containsObject:layerId]) {
        size = CGSizeMake(PipeLeakCalloutViewWidth*2, PipeLeakCalloutViewHeight);
    }else {
        size = CGSizeMake(PipeLeakCalloutViewWidth, PipeLeakCalloutViewHeight);
    }
    callout.size = size;
    return callout;
}

- (void)registerQueryPipeComplication:(QueryPipeComplication)complication {
    self.queryPipeComplication = complication;
}

- (AGSPoint *)tapLocationForDisplayCalloutView {
    return self.tapLocation;
}

- (AGSGraphic *)pointGraphicForDisplayIdentityResultInMapViewWithGeometry:(AGSGeometry *)geometry attributes:(NSDictionary *)attributes {
    switch (_type) {
        case 0:
            return [[Z3GraphicFactory factory] buildPipeLeakValvesMarkGraphicWithPoint:(AGSPoint *)geometry attributes:attributes];
            break;
        case 1:
            return [[Z3GraphicFactory factory] buildPipeNodeMarkGraphicWithPoint:(AGSPoint *)geometry attributes:attributes];
            break;
        case 2:
            return nil;
            break;
        default:
            return [[Z3GraphicFactory factory] buildUsersMarkGraphicWithPoint:(AGSPoint *)geometry attributes:attributes];
            break;
    }
}

- (AGSGeometry *)identityContext:(Z3MapViewIdentityContext *)context
             didTapAtScreenPoint:(CGPoint)screenPoint
                        mapPoint:(AGSPoint *)mapPoint {
   return [super identityContext:context didTapAtScreenPoint:screenPoint mapPoint:mapPoint];
}

- (void)identityContextQuerySuccess:(Z3MapViewIdentityContext *)context
                           mapPoint:(nonnull AGSPoint *)mapPoint
                    identityResults:(nonnull NSArray *)results
                        displayType:(NSInteger)displayType {
    //过滤爆管点
    __block double tmpDistance = 100000000000;
    __block Z3MapViewIdentityResult *reslut = nil;
    __block AGSPoint *tapLocation = nil;
    [results enumerateObjectsUsingBlock:^(Z3MapViewIdentityResult *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.geometryType isEqualToString:@"esriGeometryPolyline"]) {
            AGSPolyline *line = (AGSPolyline *) [AGSGeometryEngine projectGeometry:[obj geometry] toSpatialReference:self.mapView.spatialReference];
            AGSProximityResult *proximityResult  = [AGSGeometryEngine nearestCoordinateInGeometry:line toPoint:mapPoint];
            AGSPoint  *temPoint = proximityResult.point;
            double distance = [AGSGeometryEngine distanceBetweenGeometry1:temPoint geometry2:mapPoint];
            if (distance < tmpDistance) {
                tmpDistance = distance;
                reslut = obj;
                tapLocation = temPoint;
            }
        }
    }];
    self.tapLocation = mapPoint;
    self.result = reslut;
    [super identityContextQuerySuccess:context mapPoint:mapPoint identityResults:@[reslut] displayType:displayType];
    [self displayPipeLeakGraphicWithGeometry:tapLocation];
    if (self.queryPipeComplication) {
        self.queryPipeComplication(reslut);
    }
    [self post:Z3MapViewDidSelectDeviceNotification message:@[reslut]];
    
}

- (void)identityContextAnaylseInfluenceSuccess:(Z3MapViewIdentityContext *)context
                        pipeAnaylseResult:(Z3MapViewPipeAnaylseResult *)result {
    //将数据显示到图层上
    [self.displayIdentityResultContext updatePipeAnalyseResult:result mapPoint:self.tapLocation];
    [self post:Z3MapViewQueryLeakPipeXtdAnaylseSuccessNotification message:result];
}

- (void)identityContextAnaylseInfluenceFailure:(Z3MapViewIdentityContext *)context {
    [self post:Z3MapViewQueryLeakPipeXtdAnaylseFailureNotification message:nil];
}

- (void)identityGraphicFailure {
    [self.displayIdentityResultContext setSelectedIdentityGraphic:nil mapPoint:self.tapLocation displayType:0];
    [self.mapView.callout dismiss];
}
    
- (void)calloutView:(UIView *)sender closeValve:(NSString *)valveId {
    if(nil == valveId){
        [self showToast:@"阀门id为空！"];
        return;
    }
        
    [self.mset addObject:valveId];
    NSString *valveIds = [[self.mset allObjects] componentsJoinedByString:@","];
    [self searchRelativeValves:valveIds];
}

- (void)showToast:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.targetViewController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)searchRelativeValves:(NSString *)valveNods {
    NSString *layerID = [NSString stringWithFormat:@"%ld",self.result.layerId];
    NSString *objectId;
    if([self.result.attributes containsObjectForKey:@"GID"]){
        objectId = self.result.attributes[@"GID"];
    }else{
        objectId = self.result.attributes[@"gid"];
    }
    
    NSDictionary *arguments = @{
                                @"layerId":layerID,
                                @"objectId":objectId ?:@"",
                                @"valveNods":valveNods?:@""
                                };
    
    Z3MobileTask *task = [[Z3QueryTaskHelper helper] queryTaskWithName:SPACIAL_SEARCH_URL_TASK_NAME];
    NSString *identityURL = [task.baseURL stringByAppendingPathComponent:@"PipeAnalyse/accident"];
    [self.identityContext analyseInfluencedAreaWithGisServer:identityURL
                                                 geometry:self.tapLocation
                                                 userInfo:arguments];

}
    
- (void)switchDisplayFeatues:(NSArray *)features closeArea:(nonnull AGSPolygon *)closeArea type:(NSUInteger)type{
    _type = type;
    [self.displayIdentityResultContext updatePipeAnalyseResults:features closeArea:closeArea mapPoint:self.tapLocation];
}

- (void)displayPipeLeakGraphicWithGeometry:(AGSPoint *)geometry {
    AGSGraphic *graphic = [[Z3GraphicFactory factory] buildPipeLeakMarkGraphicWithPoint:geometry attributes:nil];
    graphic.zIndex = 2;
    [self.queryGraphicsOverlay.graphics addObject:graphic];
    [graphic setSelected:YES];
    
}
    
- (void)clearAnalyseResults {
    [self dismiss];
    [_mset removeAllObjects];
}

- (void)dismiss {
    [super dismiss];
    [self dissmissPipeLeakGraphic];
    [self post:Z3MapViewDeselectDeviceNotification message:nil];
}

- (void)dissmissPipeLeakGraphic {
    if (self.queryGraphicsOverlay) {
        [self.queryGraphicsOverlay.graphics removeAllObjects];
    }
}

- (NSMutableSet *)mset {
    if (!_mset) {
        _mset = [[NSMutableSet alloc] init];
    }
    return _mset;
}


@end
