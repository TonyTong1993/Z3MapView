//
//  Z3MapViewIdentityResult.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewIdentityResult.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3CoordinateConvertFactory.h"
#import "Z3MobileConfig.h"
@implementation Z3MapViewIdentityResult
@synthesize geometry = _geometry,attributes = _attributes;
- (CLLocation *)destination {
   return [[Z3CoordinateConvertFactory factory] locaitonWithGeometry:self.geometry];
}

#warning 因项目而定
//FACILITYID gid INSTALL_DATE
- (NSArray *)displayProperties {
    NSString *gid = self.attributes[@"gid"] ?: @"";
    NSString *code = self.attributes[@"FACILITYID"] ?:@"";
    NSString *installDate = self.attributes[@"INSTALL_DATE"] ?:@"";
    return @[
             gid,
             code,
             installDate,
             ];
}

- (NSString *)dispayText {
    NSString *code = self.attributes[@"FACILITYID"] ?:@"";
    NSString *no = NSLocalizedString(@"mt_field_pipe_num", @"编号");
    return [NSString stringWithFormat:@"%@ %@:%@",self.value,no,code];
}

- (NSMutableDictionary<NSString *,id> *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableDictionary dictionary];
    }
    return _attributes;
}


@end
