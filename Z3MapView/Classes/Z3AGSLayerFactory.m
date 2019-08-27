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
@implementation Z3AGSLayerFactory
+ (instancetype)factory {
    return [[super alloc] init];
}

- (NSArray *)loadMapLayers {
    Z3MapConfig *config =  [Z3MobileConfig shareConfig].mapConfig;
    NSArray *sources = config.sources;
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
    if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgislocaltiledlayer"]) {
        
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgistiledmapservicelayer"]) {
        NSAssert(mapLayer.url.length, @"map layer url if not valid");
        NSURL *url = [NSURL URLWithString:mapLayer.url];
        AGSArcGISTiledLayer *layer = [[AGSArcGISTiledLayer alloc] initWithURL:url];
        layer.minScale = [mapLayer.dispMinScale doubleValue];
        layer.maxScale = [mapLayer.dispMaxScale doubleValue];
       [layer setLayerID:mapLayer.ID];
        return layer;
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgisfeaturelayer"]) {
        NSAssert(false, @"AGSFeatureLayer not support");
        
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"arcgisdynamicmapservicelayer"]) {
        NSAssert(mapLayer.url.length, @"map layer url if not valid");
        NSURL *url = [NSURL URLWithString:mapLayer.url];
        AGSArcGISMapImageLayer *layer = [[AGSArcGISMapImageLayer alloc] initWithURL:url];
        layer.minScale = 520000; //[mapLayer.dispMinScale doubleValue];
        layer.maxScale = [mapLayer.dispMaxScale doubleValue];
        [layer setLayerID:mapLayer.ID];
        return layer;
    }else if ([[mapLayer.sourceType lowercaseString] isEqualToString:@"agcgisvectortiledlayer"]) {
        NSAssert(mapLayer.url.length, @"map layer url if not valid");
        NSURL *url = [NSURL URLWithString:mapLayer.url];
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
        NSURL *url = [NSURL URLWithString:mapLayer.url];
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
    AGSArcGISTiledLayer *baseMapLayer = (AGSArcGISTiledLayer *)[self localBaseMapLayer];
    return [[AGSBasemap alloc] initWithBaseLayer:baseMapLayer];
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
                    [layers addObject:layer];
                }
            }
            complicationHandler([layers copy]);
        }];
    }
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
    
    [Z3MobileConfig shareConfig].mapConfig.sources = @[lines,points];
    
}

- (void)filterSubLayesForOnLineWithAGSArcGISMapImageLayer:(AGSArcGISMapImageLayer *)layer
                                                      ids:(NSArray *)ids
                                                  visible:(BOOL)visible{
    NSArray *mapImageSublayers =  layer.mapImageSublayers;
    NSArray *sources = [Z3MobileConfig shareConfig].mapConfig.sources;
    NSMutableArray *lines = [sources firstObject];
    NSMutableArray *points = [sources lastObject];
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

@end
