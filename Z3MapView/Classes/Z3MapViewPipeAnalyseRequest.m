//
//  Z3MapViewPipeAnalyseRequest.m
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewPipeAnalyseRequest.h"
#import "Z3MapViewPipeAnalyseResponse.h"
@implementation Z3MapViewPipeAnalyseRequest
- (Class)responseClasz {
    return [Z3MapViewPipeAnalyseResponse class];
}
@end

@implementation Z3MapViewQueryInflenceUsersRequest
- (Class)responseClasz {
    return [Z3MapViewQueryInflenceUsersResponse class];
}
@end
