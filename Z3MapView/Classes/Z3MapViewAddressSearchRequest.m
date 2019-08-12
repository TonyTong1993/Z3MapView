//
//  Z3MapViewAddressSearchRequest.m
//  AMP
//
//  Created by ZZHT on 2019/8/7.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewAddressSearchRequest.h"
#import "Z3MapViewAddressSearchResponse.h"
@implementation Z3MapViewAddressSearchRequest
- (Class)responseClasz {
    return [Z3MapViewAddressSearchResponse class];
}
@end
