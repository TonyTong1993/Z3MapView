//
//  Z3FeatureLayer.h
//  AMP
//
//  Created by ZZHT on 2019/7/26.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Z3FeatureLayer : NSObject<YYModel>
@property (nonatomic,copy) NSString *dname;
@property (nonatomic,assign) NSInteger layerid;
@property (nonatomic,assign) NSInteger geotype;
@property (nonatomic,assign) NSInteger dno;
@property (nonatomic,assign) NSInteger bsprop;
@property (nonatomic,copy) NSArray *fields;
@end

NS_ASSUME_NONNULL_END
