//
//  Z3GISMeta.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/NSObject+YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface Z3GISMeta : NSObject<YYModel>
@property (nonatomic,copy) NSString *code;

/**
 type:4->管网
 */
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *layername;
@property (nonatomic,copy) NSString *descripe;
@property (nonatomic,copy) NSString *layerid;
@property (nonatomic,copy) NSString *db_mode;
@property (nonatomic,copy) NSArray  *net;
@end


NS_ASSUME_NONNULL_END
