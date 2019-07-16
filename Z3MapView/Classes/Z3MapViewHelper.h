//
//  Z3MapViewHelper.h
//  OutWork
//
//  Created by 童万华 on 2019/7/13.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface Z3MapViewHelper : NSObject
+ (instancetype)helper;

- (void)openMapWithDestination:(CLLocation *)destination
             addressDictionary:(NSDictionary * _Nullable )addressDictionary;
@end

NS_ASSUME_NONNULL_END
