//
//  Z3MapViewIdentityResult.h
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//
/*
  gid": "147384",
 "dno": "4",
 "编号": "JF4853090002",
 "横座标": "53164.125000",
 "纵座标": "48408.997000",
 "地面标高": "3.204000",
 "埋深": "1.400000",
 "开关状态": "开启",
 "目前状况": "有效",
 "阀门编号": "",
 "所在位置": "人民路北延",
 "种类": "",
 "口径": "300",
 "类型": "",
 "品牌": "",
 "调节阀门圈数": "",
 "路面箱规格": "",
 "备注": "",
 "点类型": "阀门",
 "规格": "",
 "本点号": "pj0710061",
 "阀门类型": "闸阀",
 "所在图幅": "485309",
 "建设年代": "2008-12-08",
 "敷设日期": "2008-12",
 "组分类型": "4",
 "资产原值": "0.000000",
 "折旧现值": "0.000000",
 "资产净值": "0.000000",
 "累计已提折旧": "0.000000",
 "是否报废": "0",
 "是否冻结": "0",
 "资产工程编号": "OLDPJXC",
 "巡检区域编号": "",
 "多媒体": "",
 "录入时间": "2009-07-20 00:00:00",
 "关断方向": "-1",
 "区域用途": "平江新城",
 "深度保养": "2012-11-16 00:00:00",
 "名称": "",
 "型号": "",
 "压力": "",
 "适用介质": "",
 "适用温度": "",
 "出厂编号": "",
 "出厂日期": "1900-01-01 00:00:00",
 "标准": "",
 "阀门井箱维护": "",
 "angle": "350.63",
 "hasAttachment": "",
 "isGS": "0",
 "guid": ""
 */
#import <Foundation/Foundation.h>
#import "YYKit.h"
NS_ASSUME_NONNULL_BEGIN
@class AGSGeometry;
@interface Z3MapViewIdentityResult : NSObject<YYModel>
@property (nonatomic,assign) NSInteger layerId;
@property (nonatomic,copy) NSString *layerName;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy) NSString *displayFieldName;
@property (nonatomic,copy) NSDictionary *attributes;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *geometryType;
@property (nonatomic,copy) NSDictionary *geometry;
//获取IdentityResult的地理信息 构建点类型
- (AGSGeometry *)toGeometry;


@end

NS_ASSUME_NONNULL_END
