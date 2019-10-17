//
//  Z3CovertedLocationDataSource.m
//  AMP
//
//  Created by ZZHT on 2019/9/23.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3CovertedLocationDataSource.h"
#import "Z3LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "Z3CoordinateConvertFactory.h"
#import "Z3BaseRequest.h"
@interface Z3CovertedLocationDataSource()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) Z3BaseRequest *request;
@end
@implementation Z3CovertedLocationDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.distanceFilter = 50;
        _manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return self;
}


static NSErrorDomain domain = @"zzht.com.CovertedLocationDataSource";
static NSUInteger code = 400;
-(void)doStart {
    NSError *error = nil;
    if (![CLLocationManager locationServicesEnabled]) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"locaiton services disable"};
        error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
        [self didStartOrFailWithError:error];
        return;
    }
    
    if (![CLLocationManager headingAvailable]) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"heading is not available"};
        error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
        
//        return;
    }
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"locaiton services authorization status is Denied"};
            error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"locaiton services authorization status is restricted"};
            error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
        }
            break;
        default:
            break;
    }
    
    [self.manager startUpdatingLocation];
    [self.manager startUpdatingHeading];
    [self didStartOrFailWithError:error];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [manager requestWhenInUseAuthorization];
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    double horizontalAccuracy = location.horizontalAccuracy;
    double velocity = location.speed;
    double course = location.course;
    double lastKnown = YES;
    if ([self.request isExecuting]) {
        [self.request.requestTask cancel];
    }
     __weak typeof(self) weakSelf = self;
    Z3BaseRequest *request = [[Z3CoordinateConvertFactory factory] requestConvertWGS48Location:location complication:^(AGSPoint * _Nonnull point) {
        AGSLocation *agsLocation = [[AGSLocation alloc] initWithPosition:point horizontalAccuracy:horizontalAccuracy velocity:velocity course:course lastKnown:lastKnown];
        [weakSelf didUpdateLocation:agsLocation];
    }];
    self.request = request;
   
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    [self didUpdateHeading:newHeading.trueHeading];
}

-(void)doStop {
    [self.manager stopUpdatingLocation];
    [self.manager stopUpdatingHeading];
    [self didStop];
}




@end
