//
//  Z3MapViewIdentityParameterBuilder.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSGeometry;
@interface Z3MapViewIdentityParameterBuilder : NSObject
+ (instancetype)builder;
- (NSDictionary *)buildIdentityParameterWithGeometry:(AGSGeometry *)geometry
                                                wkid:(NSInteger)wkid
                                           mapExtent:(AGSGeometry *)mapExtent
                                           tolerance:(double)tolerance
                                            userInfo:(NSDictionary *)userInfo;
- (NSDictionary *)buildQueryParameterWithGeometry:(AGSGeometry *)geometry
                                         userInfo:(NSDictionary *)userInfo;

- (NSDictionary *)buildPipeAnalyseParameterWithGeometry:(AGSGeometry *)geometry
                                               userInfo:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
