//
//  Z3MapPOI.h
//  AMP
//
//  Created by ZZHT on 2019/8/7.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AGSGeometry;
@interface Z3MapPOI : NSObject
///备注Field
@property (nonatomic, copy)   NSString     *remarkField;
///图层Field
@property (nonatomic, copy)   NSString     *layerName;
///标题Field
@property (nonatomic, copy)   NSString     *titleField;
//类型Field
@property (nonatomic,copy)    NSString     *type;
//keyField
@property (nonatomic,copy)    NSString     *keyFieldName;
//keyValue
@property (nonatomic,copy)    NSString     *keyValue;
//地址类型
@property (nonatomic,copy)    NSString     *geometryType;

//地址字典 包含x,y信息
@property (nonatomic,copy)    NSDictionary *geometry;

//属性字典
@property (nonatomic,copy)    NSDictionary *attributes;

- (AGSGeometry *)toGeometry;
- (NSString *)address;
@end

NS_ASSUME_NONNULL_END
