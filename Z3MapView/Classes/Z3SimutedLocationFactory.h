//
//  ZZSimutedLocationFactory.h
//  OutWork
//
//  Created by 童万华 on 2019/7/6.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CLLocation,AGSPolyline;
@interface Z3SimutedLocationFactory : NSObject
+ (instancetype)factory;
- (AGSPolyline *)buildSimulatedPolyline;
- (NSArray *)buildSimulatedLocations;
@end

NS_ASSUME_NONNULL_END
