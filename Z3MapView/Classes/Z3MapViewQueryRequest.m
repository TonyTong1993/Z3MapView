//
//  Z3MapViewQueryRequest.m
//  AMP
//
//  Created by ZZHT on 2019/7/29.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewQueryRequest.h"
#import "Z3MapViewQueryResponse.h"

@implementation Z3MapViewQueryRequest
- (Class)responseClasz {
    
    return [Z3MapViewQueryResponse class];
}
@end
