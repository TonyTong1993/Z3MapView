    //
    //  Z3AGSLayerFactory.m
    //  Z3MapView_Example
    //
    //  Created by 童万华 on 2019/6/18.
    //  Copyright © 2019 Tony Tony. All rights reserved.
    //

#import "Z3AGSLayerFactory.h"
#import "Z3MobileConfig.h"
#import "Z3MapConfig.h"
#import <ArcGIS/ArcGIS.h>
#import <YYKit/YYKit.h>
#import "MBProgressHUD+Z3.h"
#import "Z3URLConfig.h"
@implementation Z3AGSLayerFactory
+ (instancetype)factory {
    return [[super alloc] init];
}

- (NSArray *)loadMapLayers {
    Z3MapConfig *config =  [Z3MobileConfig shareConfig].mapConfig;
    NSArray *sources = [config mapLayers];
    NSMutableArray *layers = [NSMutableArray arrayWithCapacity:sources.count];
    for (Z3MapLayer *mapLayer in sources) {
        AGSLayer *layer = [self loadMapLayer:mapLayer];
        if (layer != nil) {
            layer.visible = mapLayer.visible;
            [layers addObject:layer];
        }
    }
    return layers;
}

- (AGSLayer *)loadMapLayer:(Z3MapLayer *)mapLayer {
    if (mapLayer == nil) {
        return nil;
    }
    NSString *rootURLPath  = [Z3URLConfig configration].rootURLPath;
    NSString *proxyURL = mapLayer.url;
    NSString *urlStr  = nil;
    if ([proxyURL hasPrefix:@"http"]) {
        urlStr = mapLayer.url;
    }else {
       urlStr = [NSString stringWithFormat:@"%@/%@",rootURLPath,proxyURL];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgislocaltiledlayer"]) {
        
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgistiledmapservicelayer"]) {
        NSAssert(mapLayer.url.length, @"map layer url if not valid");
        AGSArcGISTiledLayer *layer = [[AGSArcGISTiledLayer alloc] initWithURL:url];
        layer.minScale = [mapLayer.dispMinScale doubleValue];
        layer.maxScale = [mapLayer.dispMaxScale doubleValue];
       [layer setLayerID:mapLayer.ID];
        return layer;
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgisfeaturelayer"]) {
        NSAssert(false, @"AGSFeatureLayer not support");
        
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgisdynamicmapservicelayer"]) {
        NSAssert(mapLayer.url.length, @"map layer url if not valid");
        AGSArcGISMapImageLayer *layer = [[AGSArcGISMapImageLayer alloc] initWithURL:url];
        layer.minScale = 520000; //[mapLayer.dispMinScale doubleValue];
        layer.maxScale = [mapLayer.dispMaxScale doubleValue];
        [layer setLayerID:mapLayer.ID];
        return layer;
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"agcgisvectortiledlayer"]) {
        NSAssert(mapLayer.url.length, @"map layer url if not valid");
        AGSArcGISMapImageLayer *layer = [[AGSArcGISMapImageLayer alloc] initWithURL:url];
//        layer.minScale = [mapLayer.dispMinScale doubleValue];
//        layer.maxScale = 250;//[mapLayer.dispMaxScale doubleValue];
        [layer setLayerID:mapLayer.ID];
        return layer;
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgisimageservicelayer"]) {
        /*layers which display pre-cached maps from tiled services*/
        NSAssert(false, @"AGSServiceImageTiledLayer not support");
            //        [[AGSServiceImageTiledLayer alloc] initWithTileInfo:<#(nonnull AGSTileInfo *)#> fullExtent:<#(nonnull AGSEnvelope *)#>]
    
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"ecitytiledmapservicelayer"]) {
        AGSArcGISTiledLayer *layer = [[AGSArcGISTiledLayer alloc] initWithURL:url];
        [layer setLayerID:mapLayer.ID];
        return layer;
        /* 支持缓存的标准在线瓦片服务*/
//        NSAssert(false, @"ecitytiledmapservicelayer not support");
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"wmtslayer"]) {
        NSAssert(false, @"AGSWMTSLayer not support");
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"dblayer"]) {
        
    }
    
    return nil;
}

- (AGSBasemap *)localBaseMap {
    AGSArcGISTiledLayer *baseMapLayer = (AGSArcGISTiledLayer *)[self localBaseMapLayer];
   return [[AGSBasemap alloc] initWithBaseLayer:baseMapLayer];
}

- (AGSBasemap *)onlineBaseMap {
    Z3MapConfig *config =  [Z3MobileConfig shareConfig].mapConfig;
    Z3MapLayer *mapLayer = [config visiableBasemap];
    AGSBasemap *basemap = [[AGSBasemap alloc] initWithBaseLayer:[self loadMapLayer:mapLayer]];
    return basemap;
}

- (AGSBasemap *)onlineBaseMapWithMapLayer:(Z3MapLayer *)mapLayer {
    AGSBasemap *basemap = [[AGSBasemap alloc] initWithBaseLayer:[self loadMapLayer:mapLayer]];
    if (basemap == nil) {
        return [AGSBasemap imageryBasemap];
    }
    return basemap;
}

- (AGSLayer *)localBaseMapLayer {
    NSString *documentsPath = [UIApplication sharedApplication].documentsPath;
    NSString *tpkFilePath = [documentsPath stringByAppendingPathComponent:@"mwdt.tpk"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tpkFilePath]) {
        NSAssert(false, @"local tpk file not exist");
    }
    AGSArcGISTiledLayer *baseMapLayer = [[AGSArcGISTiledLayer alloc] initWithURL:[NSURL URLWithString:tpkFilePath]];
    return baseMapLayer;
}

    //TODO:离线图层 从.tpk/.vtpk中加载离线图层
- (AGSLayer *)loadOfflineMapLayer:(Z3MapLayer *)mapLayer {
    NSAssert(false, @"offline map layer not support");
    if (mapLayer.url) {
        
    }
    return nil ;
}

    //TODO:离线图层 从.geodatabase中加载离线图层
- (void)loadOfflineMapLayersFromGeoDatabase:(void (^)(NSArray *layers))complicationHandler {
    // Do any additional setup after loading the view, typically from a nib.
    //    AGSSyncGeodatabaseParameters *syncGeodatabaseParameters = [AGSSyncGeodatabaseParameters syncGeodatabaseParameters];
    //    syncGeodatabaseParameters.geodatabaseSyncDirection = AGSSyncDirectionDownload;
    //
    //        //指明图层的同步方向
    //    AGSSyncLayerOption *sync1001LayerOption = [AGSSyncLayerOption syncLayerOptionWithLayerID:1001 syncDirection:AGSSyncDirectionDownload];
    //    AGSSyncLayerOption *sync1002LayerOption = [AGSSyncLayerOption syncLayerOptionWithLayerID:1002 syncDirection:AGSSyncDirectionUpload];
    //    syncGeodatabaseParameters.layerOptions = @[sync1001LayerOption,sync1002LayerOption];
    //        //失败回滚
    //    syncGeodatabaseParameters.rollbackOnFailure = true;
    //
    //
    //    AGSGenerateGeodatabaseParameters *generateGeodatabaseParameters = [AGSGenerateGeodatabaseParameters generateGeodatabaseParameters];
    //
    //    generateGeodatabaseParameters.attachmentSyncDirection = AGSAttachmentSyncDirectionBidirectional;
    //        //设置更新范围
    //    NSArray<AGSPoint *> *points = @[];
    //    generateGeodatabaseParameters.extent = [AGSPolygon polygonWithPoints:points];
    //
    //    AGSGenerateLayerOption *generate1001LayerOption = [[AGSGenerateLayerOption alloc] initWithLayerID:1001];
    //        //待理解
    //    generate1001LayerOption.queryOption = AGSGenerateLayerQueryOptionUseFilter;
    //        //
    //    generate1001LayerOption.useGeometry = true;
    //    AGSGenerateLayerOption *generate1002LayerOption = [[AGSGenerateLayerOption alloc] initWithLayerID:1002 whereClause:@""];
    //    AGSGenerateLayerOption *generate1003LayerOption = [[AGSGenerateLayerOption alloc] initWithLayerID:1003 includeRelated:true];
    //    generateGeodatabaseParameters.layerOptions = @[generate1001LayerOption,generate1002LayerOption,generate1003LayerOption];
    //        //用于本地坐标系与服务坐标系不一致时
    //    generateGeodatabaseParameters.outSpatialReference = [AGSSpatialReference WGS84];
    //        //指明是同步整个数据库，还是同步某些图层
    //    generateGeodatabaseParameters.syncModel = AGSSyncModelGeodatabase;
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *geodatabasePath = [documents stringByAppendingPathComponent:@"mwgss.geodatabase"];
    NSURL *gdbURL = [NSURL URLWithString:geodatabasePath];
    NSString *localDBPath = [documents stringByAppendingString:@"package"];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:geodatabasePath];
    NSMutableArray *layers = [[NSMutableArray alloc] init];
    if (isExist) {
        AGSGeodatabase *gdb =  [[AGSGeodatabase alloc] initWithFileURL:gdbURL];
        [gdb loadWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                [MBProgressHUD showError:NSLocalizedString(@"str_toast_load_offline_map_failure", @"加载离线图层失败") ];
            }else {
                NSArray *tables = gdb.geodatabaseFeatureTables;
                for (AGSGeodatabaseFeatureTable *table in tables) {
                    AGSFeatureLayer *layer = [[AGSFeatureLayer alloc] initWithFeatureTable:table];
                    NSInteger serviceLayerID =  table.serviceLayerID;
                    AGSPictureMarkerSymbol *symbol = nil;
                    switch (serviceLayerID) {
                            case 2:
                           symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"valve"]];
                            break;
                            case 3:
                            symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"hydrant"]];
                            break;
                            case 4:
                            symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"TAPVALVE"]];
                            break;
                            case 5:
                            symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"DILIVERY_POINT"]];
                            break;
                            case 6:
                            symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"B.I"]];
                            break;
                            case 7:
                            symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"PUMP"]];
                            break;
                        default:
                            break;
                    }
                    if (symbol) {
                        layer.renderer = [[AGSSimpleRenderer alloc] initWithSymbol:symbol];
                    }
                    [layers addObject:layer];
                }
            }
            complicationHandler([layers copy]);
        }];
    }
}

- (void)loadOfflineGeoDatabaseWithFileName:(NSString *)fileName complicationHandler:(void (^)(NSArray * layers,  NSError* error))complicationHandler {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *packageDirectory = [documentDirectory stringByAppendingPathComponent:@"package"];
    NSString *targetDirectory = [packageDirectory stringByAppendingPathComponent:fileName];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:targetDirectory];
    if (isExist) {
        NSURL *gdbURL = [NSURL URLWithString:targetDirectory];
        AGSGeodatabase *gdb =  [[AGSGeodatabase alloc] initWithFileURL:gdbURL];
        [gdb loadWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                complicationHandler(nil,error);
                return;
            }
           NSArray *layers = [self loadFeatureLayerFormGeoDatabase:gdb];
            complicationHandler(layers,nil);
        }];
    }else {
        NSErrorDomain domain = @"zzht.load.layer.failure";
        NSInteger code = 404;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:@"Not Found",
                                   };
        NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
         complicationHandler(nil,error);
    }
    
}

- (NSArray *)loadFeatureLayerFormGeoDatabase:(AGSGeodatabase *)gdb {
    NSArray *tables = gdb.geodatabaseFeatureTables;
    NSMutableArray *layers = [NSMutableArray array];
    for (AGSGeodatabaseFeatureTable *table in tables) {
        AGSFeatureLayer *layer = [[AGSFeatureLayer alloc] initWithFeatureTable:table];
        [layers addObject:layer];
    }
    return [layers copy];
}

- (void)subLayersForOnlineWithAGSArcGISMapImageLayer:(AGSArcGISMapImageLayer *)layer {
    NSArray *mapImageSublayers =  layer.mapImageSublayers;
    NSMutableArray *lines = [NSMutableArray array];
    NSMutableArray *points = [NSMutableArray array];
    NSArray *contents = layer.subLayerContents;
    for (int i = 0; i < mapImageSublayers.count; i++) {
        AGSArcGISMapImageSublayer *subLayer = mapImageSublayers[i];
        id<AGSLayerContent> content = contents[i];
        Z3MapLayer *mapLayer = [[Z3MapLayer alloc] init];
        mapLayer.name = subLayer.name;
        mapLayer.visible = subLayer.visible;
        mapLayer.ID = [@(subLayer.sublayerID) stringValue];
#warning 区分不同类型的图层
        if (content.subLayerContents.count) {
              [lines addObject:mapLayer];
        }else {
             [points addObject:mapLayer];
        }
    }
    
    [Z3MobileConfig shareConfig].mapConfig.layers = @[lines,points];
    
}

- (void)filterSubLayesForOnLineWithAGSArcGISMapImageLayer:(AGSArcGISMapImageLayer *)layer
                                                      ids:(NSArray *)ids
                                                  visible:(BOOL)visible{
    if (layer == nil) {
        return;
    }
    NSArray *mapImageSublayers =  layer.mapImageSublayers;
    NSArray *sources = [Z3MobileConfig shareConfig].mapConfig.sources;
    NSMutableArray *lines = [sources firstObject];
    NSMutableArray *points = [sources lastObject];
    //TODO:FIX crash 100 图层加载失败,此处无法获取到数据
    [ids enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger layerId = [obj integerValue];
        for (AGSArcGISMapImageSublayer *layer in mapImageSublayers) {
            if (layerId == layer.sublayerID) {
                layer.visible = visible;
            }
        }
        
        for (Z3MapLayer *layer in lines) {
            if (layerId == [layer.ID integerValue]) {
                layer.visible = visible;
            }
        }
        
        for (Z3MapLayer *layer in points) {
            if (layerId == [layer.ID integerValue]) {
                layer.visible = visible;
            }
        }
    }];
    
}

- (NSArray *)offlineGeodatabaseFileNames {
    NSArray *fileNames = @[
                           @"PIPE00.geodatabase",
                           @"PIPE01.geodatabase",
                           @"PIPE02.geodatabase",
                           @"PIPE03.geodatabase",
                           @"PIPE04.geodatabase",
                           @"B.I..geodatabase",
                           @"BLANKING_FLANGE.geodatabase",
                           @"COUPLING.geodatabase",
                           @"CROSS.geodatabase",
                           @"DILIVERY_POINT.geodatabase",
                           @"COUPLING.geodatabase",
                           @"EXPANSION.geodatabase",
                           @"HYDRANT.geodatabase",
                           @"METER.geodatabase",
                           @"NSTRUCTURE.geodatabase",
                           @"PUMP.geodatabase",
                           @"REDUCER.geodatabase",
                           @"SAMPLE.geodatabase",
                           @"SERCON00.geodatabase",
                           @"SERCON01.geodatabase",
                           @"TAP.geodatabase",
                           @"TAPVALVE.geodatabase",
                           @"TEE.geodatabase",
                           @"TOPO_POINT.geodatabase",
                           @"TRANSITION.geodatabase",
                           @"VALVE00.geodatabase"
                           ];
    
    return fileNames;
}
    
- (NSArray *)loadLayersByLocalShapefiles {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *shapesPath = [documentsDirectory stringByAppendingPathComponent:@"shapes"];
    NSError * __autoreleasing error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:shapesPath error:&error];
    if (error) {
        NSAssert(false, [error localizedDescription]);
    }
    NSString *regex = @".*shp$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSArray *targets = [contents filteredArrayUsingPredicate:predicate];
    NSMutableArray *layers = [NSMutableArray array];
    for (NSString *fileName in targets) {
        NSString *shapePath = [shapesPath stringByAppendingPathComponent:fileName];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:shapePath];
        AGSShapefileFeatureTable *table = [[AGSShapefileFeatureTable alloc] initWithFileURL:fileURL];
        AGSFeatureLayer *layer = [[AGSFeatureLayer alloc] initWithFeatureTable:table];
        [layers addObject:layer];
    }
    return layers;
}

@end
