//
//  Z3BuildSimulatedLocationDataSourceContext.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/7/5.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3BuildSimulatedLocationDataSourceXtd.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewPrivate.h"
#import "Z3AGSSymbolFactory.h"
@implementation Z3BuildSimulatedLocationDataSourceXtd

- (AGSSketchCreationMode)creationMode {
    return AGSSketchCreationModeFreehandPolyline;
}

//TODO: 国际化
- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    AGSPolygon *geometry = (AGSPolygon *)self.mapView.sketchEditor.geometry;
    if ((geometry == nil)&&geometry.isEmpty) return;
    double length = [AGSGeometryEngine lengthOfGeometry:geometry];
    double maxLength = 10*1000;//10公里
    if (length > maxLength) {
        [self showFailureAlert:@"模拟轨迹范围过大，请重新设置"];
        return;
    }
     double minLength = 100;//100m
    if (length > minLength) {
        [self showFinishAlert:@"已获取模拟轨迹，是否开启模拟,如果看不见用户位置图标，请重启运用"];
    }
}

- (void)showFailureAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self.targetViewController presentViewController:alert animated:YES completion:nil];
    
}

- (void)showFinishAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.mapView.sketchEditor clearGeometry];
    }];
    [alert addAction:action];
    action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AGSPolyline *line = (AGSPolyline *)self.mapView.sketchEditor.geometry;
        AGSSimulatedLocationDataSource *dataSource = [[AGSSimulatedLocationDataSource alloc] init];
        [dataSource setLocationsWithPolyline:line];
        [self.mapView.locationDisplay setDataSource:dataSource];
        [dataSource startWithCompletion:nil];
         [self dismiss];
        //保存模拟轨迹数据
        NSError * __autoreleasing error = nil;
        NSDictionary *json = [line toJSON:&error];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [document stringByAppendingPathComponent:@"simulated_trace.json"];
        BOOL success = [data writeToFile:path atomically:YES];
        NSAssert(success, @"保存模拟数据失败");
        
    }];
    [alert addAction:action];
    [self.targetViewController presentViewController:alert animated:YES completion:nil];
    
}
@end
