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

@interface Z3MapViewPipeAnalyseResponse ()
@property (nonatomic,copy) NSString *mainWhere;
@end

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
        NSDictionary *geometry = json[@"geometry"];
        identityResult.geometry = (AGSGeometry *)[AGSGeometry fromJSON:geometry error:nil];
        NSDictionary *attributes = json[@"attributes"];
        [identityResult.attributes addEntriesFromDictionary:attributes];
        [identityResult.attributes setValue:@(identityResult.layerId) forKey:@"layerId"];
        [mvalves addObject:identityResult];
    }
      result.valves = [mvalves copy];
    
    NSArray *users = usersObj[@"results"];
    NSMutableArray *musers = [[NSMutableArray alloc] init];
    NSMutableArray *factilityIDs = [NSMutableArray array];
    for (NSDictionary *json in users) {
        Z3MapViewIdentityResult *identityResult = [Z3MapViewIdentityResult modelWithJSON:json];
        NSDictionary *geometry = json[@"geometry"];
        identityResult.geometry = (AGSGeometry *)[AGSGeometry fromJSON:geometry error:nil];
        NSDictionary *attributes = json[@"attributes"];
        NSString *factilityID = attributes[@"FACILITYID"];
        [factilityIDs addObject:[NSString stringWithFormat:@"'%@'",factilityID]];
        [identityResult.attributes addEntriesFromDictionary:attributes];
        [identityResult.attributes setValue:@(identityResult.layerId) forKey:@"layerId"];
        [musers addObject:identityResult];
    }
    if (factilityIDs.count) {
        NSString *factilityIDsString = [factilityIDs componentsJoinedByString:@","];
        _mainWhere = [NSString stringWithFormat:@"FACILITYID in ( %@ )",factilityIDsString];
    }
    result.users = [musers copy];
    NSArray *closeLines = closeLinesObj[@"results"];
    NSMutableArray *mcloseLines = [[NSMutableArray alloc] init];
    for (NSDictionary *json in closeLines) {
       Z3MapViewIdentityResult *identityResult = [Z3MapViewIdentityResult modelWithJSON:json];
        NSDictionary *geometry = json[@"geometry"];
        identityResult.geometry = (AGSGeometry *)[AGSGeometry fromJSON:geometry error:nil];
        NSDictionary *attributes = json[@"attributes"];
        [identityResult.attributes addEntriesFromDictionary:attributes];
        [identityResult.attributes setValue:@(identityResult.layerId) forKey:@"layerId"];
        [mcloseLines addObject:identityResult];
    }
    result.closeLines = [mcloseLines copy];
    
    NSArray *closeNodes = closeNodesObj[@"results"];
    NSMutableArray *mcloseNodes = [[NSMutableArray alloc] init];
    for (NSDictionary *json in closeNodes) {
        Z3MapViewIdentityResult *identityResult = [Z3MapViewIdentityResult modelWithJSON:json];
        NSDictionary *geometry = json[@"geometry"];
        identityResult.geometry = (AGSGeometry *)[AGSGeometry fromJSON:geometry error:nil];
        NSDictionary *attributes = json[@"attributes"];
        [identityResult.attributes addEntriesFromDictionary:attributes];
        [identityResult.attributes setValue:@(identityResult.layerId) forKey:@"layerId"];
        [mcloseNodes addObject:identityResult];
    }
    result.closeNodes = [mcloseNodes copy];
    
    _data = result;
}

- (void)refreshRespone:(Z3MapViewQueryInflenceUsersResponse *)response {
    Z3MapViewPipeAnaylseResult *result = self.data;
    result.influenceUsers = response.data;
}
@end

@implementation Z3MapViewQueryInflenceUsersResponse

@synthesize data = _data;
- (void)toModel {
    NSInteger count = [self.responseJSONObject[@"count"] integerValue];
    _isEmpty = count <= 0;
    NSArray *features = self.responseJSONObject[@"features"];
    _data = features;
}

@end
