//
//  Z3CovertedLocationDataSource.m
//  AMP
//
//  Created by ZZHT on 2019/9/23.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3CovertedLocationDataSource.h"
#import "Z3LocationManager.h"
#import "Z3CoordinateConvertFactory.h"
#import "Z3BaseRequest.h"
#import "Z3MobileConfig.h"
@interface Z3CovertedLocationDataSource()
@property (nonatomic,strong) Z3BaseRequest *request;
@end
@implementation Z3CovertedLocationDataSource

-(void)doStart {
    NSError *error = [Z3LocationManager manager].error;
    [[Z3LocationManager manager] registerLocationDidChangeListener:^(CLLocation * _Nonnull location) {
        double horizontalAccuracy = location.horizontalAccuracy;
        double velocity = location.speed;
        double course = location.course;
        double lastKnown = YES;
        if ([self.request isExecuting]) {
            [self.request.requestTask cancel];
        }
        if ([Z3MobileConfig shareConfig].coorTransToken && location) {
            __weak typeof(self) weakSelf = self;
            Z3BaseRequest *request = [[Z3CoordinateConvertFactory factory] requestConvertWGS48Location:location complication:^(AGSPoint * _Nonnull point) {
                AGSLocation *agsLocation = [[AGSLocation alloc] initWithPosition:point horizontalAccuracy:horizontalAccuracy velocity:velocity course:course lastKnown:lastKnown];
                [weakSelf didUpdateLocation:agsLocation];
            }];
            self.request = request;
            
        }else {
            NSInteger wkid = [Z3MobileConfig shareConfig].wkid;
            AGSPoint *point = [[Z3CoordinateConvertFactory factory] pointWithCLLocation:location wkid:wkid];
            AGSLocation *agsLocation = [[AGSLocation alloc] initWithPosition:point horizontalAccuracy:horizontalAccuracy velocity:velocity course:course lastKnown:lastKnown];
            [self didUpdateLocation:agsLocation];
        }
    }];
    
    [[Z3LocationManager manager] registerLocationHeadingDidChangeListener:^(double heading) {
        [self didUpdateHeading:heading];
    }];
    [self didStartOrFailWithError:error];
}

-(void)doStop {
    [[Z3LocationManager manager] registerLocationHeadingDidChangeListener:nil];
    [[Z3LocationManager manager] registerLocationDidChangeListener:nil];
    [self didStop];
}

@end
