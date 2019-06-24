//
//  Z3GISMetaResponse.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3GISMetaResponse.h"
#import "Z3GISMeta.h"
@implementation Z3GISMetaResponse
@synthesize data = _data;
- (void)toModel {
    NSDictionary *metaJson = self.responseJSONObject;
    NSArray *metas =  metaJson[@"metainfo"];
    NSMutableArray *mMetas = [NSMutableArray arrayWithCapacity:metas.count];
    for (NSDictionary *metaInfo in metas) {
       Z3GISMeta *meta = [Z3GISMeta modelWithJSON:metaInfo];
        [mMetas addObject:meta];
    }
    _data = [mMetas copy];
}
@end
