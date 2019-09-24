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
    if ([metaJson isKindOfClass:[NSDictionary class]]) {
        NSArray *metas =  metaJson[@"metainfo"];
        NSMutableArray *mMetas = [NSMutableArray arrayWithCapacity:metas.count];
        for (NSDictionary *metaInfo in metas) {
            Z3GISMeta *meta = [Z3GISMeta modelWithJSON:metaInfo];
            [mMetas addObject:meta];
        }
        _data = [mMetas copy];
    }
}

/*
 
 1.0
 unrecognized selector sent to instance
 
 5   AMP                                 0x0000000100d57228 -[Z3GISMetaResponse toModel] + 128
 6   AMP                                 0x0000000100d9c2f8 -[Z3HttpManager handleRequestResult:responseObject:error:] + 1956
 7   AMP                                 0x0000000100d9aa38 __36-[Z3HttpManager sendGETHttpRequest:]_block_invoke + 128
 8   AMP                                 0x0000000100db6b34 __116-[AFHTTPSessionManager dataTaskWithHTTPMethod:URLString:parameters:uploadProgress:downloadProgress:success:failure:]_block_invoke.124 + 212
 9   AMP                                 0x0000000100dd8bec __72-[AFURLSessionManagerTaskDelegate URLSession:task:didCompleteWithError:]_block_invoke_2.117 + 224

 
 2.0
 <OS_dispatch_data: data[0x281284c40] = { leaf, size = 455331, buf = 0x11704c000 }>
 */
@end
