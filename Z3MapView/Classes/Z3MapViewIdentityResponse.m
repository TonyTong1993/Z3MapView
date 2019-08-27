//
//  Z3MapViewIdentityResponse.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/18.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewIdentityResponse.h"
#import "Z3MapViewIdentityResult.h"
@implementation Z3MapViewIdentityResponse
@synthesize data = _data;
- (void)toModel {
    NSDictionary *data = self.responseJSONObject;
    NSArray *results = data[@"results"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:results.count];
    for (NSDictionary *info in results) {
      Z3MapViewIdentityResult *result=  [Z3MapViewIdentityResult modelWithJSON:info];
      [models addObject:result];
    }
    _data = models;
}
@end
