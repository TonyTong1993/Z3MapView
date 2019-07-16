//
//  Z3MapViewHelper.m
//  OutWork
//
//  Created by 童万华 on 2019/7/13.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import "Z3MapViewHelper.h"
#import <MapKit/MapKit.h>
@implementation Z3MapViewHelper

+ (instancetype)helper {
    return [[super alloc] init];
}

- (void)openMapWithDestination:(CLLocation *)destination
                    addressDictionary:(NSDictionary *)addressDictionary{
    NSArray *apps = [self appsForMapWithDestination:destination];
    NSArray *titles = [apps valueForKey:@"title"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([action.title isEqualToString:@"苹果地图"]) {
                [self openAppleMapWithDestination:destination addressDictionary:addressDictionary];
            }else {
                NSUInteger index =  [titles indexOfObject:action.title];
                NSDictionary *info = apps[index];
                NSString *url = info[@"url"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }];
        [alert addAction:action];
    }
    
    UIViewController *rootViewController =  [[UIApplication sharedApplication].delegate window].rootViewController;
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)openAppleMapWithDestination:(CLLocation *)destination
                  addressDictionary:(NSDictionary *)addressDictionary {
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem*toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destination.coordinate addressDictionary:addressDictionary]];
    NSArray*items = @[currentLoc,toLocation];
    
    NSDictionary*dic = @{
                         
                         MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                         
                         MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                         
                         MKLaunchOptionsShowsTrafficKey : @(YES)
                         
                         };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

-(NSArray*)appsForMapWithDestination:(CLLocation *)location
{
    CLLocationCoordinate2D destination = [location coordinate];
    NSMutableArray*apps = [NSMutableArray array];
    NSMutableDictionary*iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] =@"苹果地图";
    [apps addObject:iosMapDic];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary*baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] =@"百度地图";
        NSString*urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=终点&mode=driving&coord_type=gcj02",destination.latitude,destination.longitude] stringByTrimmingCharactersInSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        baiduMapDic[@"url"] = urlString;
        
        [apps addObject:baiduMapDic];
        
    }
    
        //高德地图
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        NSMutableDictionary*gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] =@"高德地图";
        NSString*urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",destination.latitude,destination.longitude] stringByTrimmingCharactersInSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        gaodeMapDic[@"url"] = urlString;
        
        [apps addObject:gaodeMapDic];
        
    }
    
        //谷歌地图
        //
        //    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        //
        //        NSMutableDictionary*googleMapDic = [NSMutableDictionary dictionary];
        //
        //        googleMapDic[@"title"] =@"谷歌地图";
        //
        //        NSString*urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航测试",@"nav123456",endLocation.latitude, endLocation.longitude]stringByTrimmingCharactersInSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        //
        //        googleMapDic[@"url"] = urlString;
        //
        //        [apps addObject:googleMapDic];
        //
        //    }
    
        //腾讯地图
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary*qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] =@"腾讯地图";
        NSString*urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",destination.latitude, destination.longitude] stringByTrimmingCharactersInSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        qqMapDic[@"url"] = urlString;
        [apps addObject:qqMapDic];
        
    }
    
    return apps;
    
}
@end
