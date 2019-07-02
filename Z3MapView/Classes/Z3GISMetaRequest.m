//
//  Z3GISMetaRequest.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3GISMetaRequest.h"
#import "Z3GISMetaResponse.h"
@implementation Z3GISMetaRequest
- (Class)responseClasz {
    return [Z3GISMetaResponse class];
}
@end
