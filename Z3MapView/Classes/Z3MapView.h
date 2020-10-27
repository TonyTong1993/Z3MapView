//
//  Z3MapView.h
//  OutWork
//
//  Created by 童万华 on 2019/7/13.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSNotificationName const Z3MapViewRequestFormNotification;
extern NSNotificationName const Z3MapViewRequestDetailNotification;
extern NSNotificationName const Z3MapViewRequestDeviceFormNotification;
extern NSString * const Z3MapViewRequestFormUserInfoKey;
extern NSString * const Z3MapViewRequestDetailUserInfoKey;
extern NSString * const Z3MapViewRequestDeviceUserInfoKey;

//组合条件查询相关的通知
extern NSNotificationName const Z3MapViewIdentityFeaturesInGlobalNotification;
extern NSNotificationName const Z3MapViewIdentityFeaturesInVisibleNotification;
extern NSNotificationName const Z3MapViewIdentityFeaturesByMakeRectNotification;
extern NSNotificationName const Z3MapViewIdentityFeaturesByMakeRectComplicationNotification;
extern NSNotificationName const Z3MapViewIdentityFeaturesComplicationNotification;
extern NSNotificationName const Z3MapViewCancelIdentityFeaturesNotification;
extern NSNotificationName const Z3HUDIdentityResultDiplayViewDidChangeSelectIndexNotification;
extern NSNotificationName const Z3MapViewIdentityContextDidChangeSelectIndexNotification;
extern NSNotificationName const Z3MapViewIdentityContextDeselectIndexNotification;

//图层控制相关的通知
extern NSNotificationName const MasterViewControllerShowDetailViewNotification;
extern NSNotificationName const ZZCommonMapViewControllerShowLayerFilterViewNotification;
extern NSNotificationName const Z3MapViewLayerFilterViewControllerSelectIndexNotification;
extern NSNotificationName const Z3MapViewLayerFilterViewControllerDeselectIndexNotification;

//点击查询
extern NSNotificationName const Z3MapViewTapQueryXtdIdentitySuccessNotification;
extern NSNotificationName const Z3MapViewTapQueryXtdIdentityGraphicFailureNotification;
extern NSNotificationName const Z3TapIdentityResultViewControllerDoneNotification;
extern NSNotificationName const Z3TapIdentityResultViewControllerCancelNotification;

extern NSNotificationName const Z3MapViewIdentityContextDidTapAtScreenNotification;

//爆管分析页面数据通信
//爆管分析-点击爆管点
extern NSNotificationName const Z3PipeLeakAnalysisViewControllerQueryLeakPipeNotification;
//爆管分析-点击关阀搜索
extern NSNotificationName const Z3PipeLeakAnalysisViewControllerQueryValueNotification;
//爆管分析-点击清除
extern NSNotificationName const Z3PipeLeakAnalysisViewControllerClearNotification;
//爆管分析查看详情页
extern NSNotificationName const Z3HUDPipeLeakCalloutViewQuickLookDetailNotification;
//分析爆管点成功
extern NSNotificationName const Z3MapViewQueryLeakPipeXtdAnaylseSuccessNotification;
extern NSNotificationName const Z3MapViewQueryLeakPipeXtdAnaylseFailureNotification;
//已选中设备(如爆管点/具有关断特性的点)
extern NSNotificationName const Z3MapViewDidSelectDeviceNotification;
//已取消选中设备(如爆管点/具有关断特性的点)
extern NSNotificationName const Z3MapViewDeselectDeviceNotification;
//二次关阀
extern NSNotificationName const Z3HUDPipeLeakCalloutViewCloseValveNotification;

//工程影响范围分析面数据通信
//查询具有关阀属性的管点
extern NSNotificationName const Z3CloseValveAnalysisViewControllerQueryValveNotification;
//查询分析接口
extern NSNotificationName const Z3CloseValveAnalysisViewControllerAnalyseCloseValveNotification;


//问题反馈
extern NSNotificationName const Z3DevicePickerViewCellTapForSelectDeviceNotification;
extern NSNotificationName const Z3DevicePickerViewCellTapForReSelectDeviceNotification;
//通知去进行地图选点
extern NSNotificationName const Z3LocationChoiceCellTapForLocationDeviceNotification;
//通知取消进行地图选点
extern NSNotificationName const Z3LocationChoiceCellTapForCancelLocationDeviceNotification;
extern NSNotificationName const Z3IssueFeedbackViewControllerClearMapViewNotification;
extern NSNotificationName const Z3IssueFeedbackViewControllerFinishMapViewNotification;

//点击标记按钮
extern NSNotificationName const Z3ImagePickerCellStartMarkMapViewNotification;

//通知取消标记功能
extern NSNotificationName const ZZCommonMapViewControllerCancelMarkMapViewNotification;
extern NSNotificationName const ZZCommonMapViewControllerFinishMarkMapViewNotification;

//设备属性相关
extern NSNotificationName const Z3AGSCalloutViewIPadAddPhotoNotification;
extern NSNotificationName const Z3AGSCalloutViewIPadBrowserPhotoNotification;

extern NSString * const Z3MapViewOnlineFeatureLayerNameKey;

extern NSNotificationName const Z3MapViewLocationChangedNotification; //
extern NSString * const Z3MapViewChangedLocationInfoKey;

extern NSNotificationName const Z3MapViewPatrolPartConfirmNotification ;
extern NSString * const Z3MapViewPatrolPartConfirmInfoKey;
extern NSString * const Z3MapViewPatrolPartConfirmPartsInfoKey;
extern NSString * const Z3MapViewPatrolPartConfirmTaskInfoKey;

extern NSString * const Z3IPadUnRegistAllNotification;

@class Z3BookMark;
typedef void(^ChangeSelectedBookMarkListener)(Z3BookMark *bookMark,NSUInteger index);
typedef void(^AddBookMarkSuccess)(Z3BookMark *bookMark);
typedef void(^EditBookMarkSuccess)(NSUInteger index);
@protocol Z3MapViewBookMarkDelegate <NSObject>
- (void)showBookMarks:(NSArray *)bookMarks;
- (void)didSelectBookMark:(Z3BookMark *)bookMark atIndex:(NSUInteger)index;
- (void)deSelectBookMark:(Z3BookMark *)bookMark atIndex:(NSUInteger)index;
- (void)editBookMark:(Z3BookMark *)bookMark
             atIndex:(NSUInteger)index
        complication:(EditBookMarkSuccess)complication;
- (void)deleteBookMark:(Z3BookMark *)bookMark atIndex:(NSUInteger)index;
/**
 反向回调

 @param listener 在地图上修改选中的书签的监听器
 */
- (void)addListener:(ChangeSelectedBookMarkListener)listener;
- (void)addBookMarkWithSuccess:(AddBookMarkSuccess)success;



@end
