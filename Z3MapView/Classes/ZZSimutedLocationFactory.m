//
//  ZZSimutedLocationFactory.m
//  OutWork
//
//  Created by 童万华 on 2019/7/6.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import "Z3SimutedLocationFactory.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MobileConfig.h"
#import "CoorTranUtil.h"
#import "Z3CoordinateConvertFactory.h"
@implementation Z3SimutedLocationFactory
+ (instancetype)factory {
    return [[super alloc] init];
}

- (AGSPolyline *)buildSimulatedPolyline {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [document stringByAppendingPathComponent:@"simulated_trace.json"];
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (isExists) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSError * __autoreleasing error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSAssert(false, @"模拟轨迹点读取失败");
        }
        AGSPolyline *polyline = (AGSPolyline *)[AGSPolyline fromJSON:json error:&error];
        return polyline;
    }
    
    return [self loadSimulationTraceWithFileName:@"szsl_trace"];
}

- (NSArray *)buildSimulatedLocations {
    AGSPolyline *line = [self buildSimulatedPolyline];
    if (line == nil) {
        return nil;
    }
    NSMutableArray *points = [NSMutableArray array];
    [[line.parts array] enumerateObjectsUsingBlock:^(AGSPart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[obj.points array] enumerateObjectsUsingBlock:^(AGSPoint * _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
            CoorTranUtil *coorTrans = [Z3MobileConfig shareConfig].coorTrans;
            CGPoint position = [coorTrans CoorTransReverse:point.x Y:point.y];
            CLLocationCoordinate2D coordinate  = CLLocationCoordinate2DMake(position.x, position.y);
            CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate altitude:0.0 horizontalAccuracy:50 verticalAccuracy:50 timestamp:[NSDate date]];
            [points addObject:location];
        }];
    }];
    
    return points;
}

- (AGSPolyline *)loadSimulationTraceWithFileName:(NSString *)fileName  {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError __autoreleasing *error = nil;
    if(nil == data){
        return nil;
    }
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *trace = [result valueForKey:@"trace"];
    NSMutableArray *temp = [NSMutableArray array];
    [trace enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        double latitude = [[obj valueForKey:@"lat"] doubleValue];
        double longitude = [[obj valueForKey:@"lon"] doubleValue];
        AGSPoint *point = [[Z3CoordinateConvertFactory factory] pointWithLatitude:latitude longitude:longitude altitude:0.0 wkid:2437];
        [temp addObject:point];
    }];
    AGSPolylineBuilder *builder = [[AGSPolylineBuilder alloc] initWithPoints:temp];
    return builder.toGeometry;
}

@end
