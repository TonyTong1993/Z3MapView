//
//  Z3MapViewPipeAnalyseResponse.m
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewPipeAnalyseResponse.h"
#import "Z3MapViewPipeAnaylseResult.h"
#import "Z3MapViewIdentityResult.h"
#import <ArcGIS/ArcGIS.h>
@implementation Z3MapViewPipeAnalyseResponse
@synthesize data = _data,errorMsg = _errorMsg;
- (void)toModel {
    NSDictionary *JSONObject = self.responseJSONObject;
    NSDictionary *closeArea = JSONObject[@"closearea"];
    NSDictionary *valvesObj = JSONObject[@"valves"];
    NSDictionary *usersObj = JSONObject[@"users"];
    NSDictionary *closeLinesObj = JSONObject[@"closeLines"];
    NSDictionary *closeNodesObj = JSONObject[@"closeNodes"];
    NSString *errorMessage = JSONObject[@"errmsg"];
    BOOL success = [JSONObject[@"success"] boolValue];
    if (!success) {
        _errorMsg = errorMessage;
        return;
    }
    NSError * __autoreleasing error = nil;
    AGSPolygon *area = (AGSPolygon *)[AGSPolygon fromJSON:closeArea error:&error];
    Z3MapViewPipeAnaylseResult *result = [[Z3MapViewPipeAnaylseResult alloc] init];
    result.closearea = area;
    
    NSArray *valves = valvesObj[@"results"];
    NSMutableArray *mvalves = [[NSMutableArray alloc] init];
    for (NSDictionary *json in valves) {
       Z3MapViewIdentityResult *identityResult = [Z3MapViewIdentityResult modelWithJSON:json];
        [mvalves addObject:identityResult];
    }
      result.valves = [mvalves copy];
    
    NSArray *users = usersObj[@"results"];
    NSMutableArray *musers = [[NSMutableArray alloc] init];
    for (NSDictionary *json in users) {
        Z3MapViewIdentityResult *identityResult = [Z3MapViewIdentityResult modelWithJSON:json];
        [musers addObject:identityResult];
    }
     result.users = [musers copy];
    
    NSArray *closeLines = closeLinesObj[@"results"];
    NSMutableArray *mcloseLines = [[NSMutableArray alloc] init];
    for (NSDictionary *json in closeLines) {
        Z3MapViewIdentityResult *identityResult = [Z3MapViewIdentityResult modelWithJSON:json];
        [mcloseLines addObject:identityResult];
    }
    result.closeLines = [mcloseLines copy];
    
    NSArray *closeNodes = closeNodesObj[@"results"];
    NSMutableArray *mcloseNodes = [[NSMutableArray alloc] init];
    for (NSDictionary *json in closeNodes) {
        Z3MapViewIdentityResult *identityResult = [Z3MapViewIdentityResult modelWithJSON:json];
        [mcloseNodes addObject:identityResult];
    }
    result.closeNodes = [mcloseNodes copy];
    
    _data = result;
    
}


@end
