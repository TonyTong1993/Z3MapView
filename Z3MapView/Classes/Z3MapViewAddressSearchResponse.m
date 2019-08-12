//
//  Z3MapViewAddressSearchResponse.m
//  AMP
//
//  Created by ZZHT on 2019/8/7.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewAddressSearchResponse.h"
#import "Z3MapPOI.h"
#import <YYKit/YYKit.h>
//"results": [
//            {
//                "layerName": "ADDRESSS",
//                "type": "门牌",
//                "titleField": "DOORNO",
//                "remarkField": "DOORNO",
//                "keyValue": "30867",
//                "keyFieldName": "OBJECTID",
//                "attributes": {
//                    "DOORNO": "客商街 30"
//                },
//                "geometryType": "esriGeometryPoint",
//                "geometry": {
//                    "x": 21247.9780696624,
//                    "y": 9651.59359456112
//                }
//            }
@implementation Z3MapViewAddressSearchResponse
@synthesize data = _data;
- (void)toModel {
    NSArray *results = self.responseJSONObject[@"results"];
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:results.count];
    for (NSDictionary *json in results) {
       [datas addObject:[Z3MapPOI modelWithJSON:json]];
    }
    _data = datas;
}
@end
