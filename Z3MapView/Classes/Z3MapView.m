//
//  Z3MapView.m
//  OutWork
//
//  Created by 童万华 on 2019/7/13.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import "Z3MapView.h"
 NSNotificationName const Z3MapViewRequestFormNotification = @"zzht.mapview.request.form";
 NSNotificationName const Z3MapViewRequestDetailNotification = @"zzht.mapview.request.detail";
 NSString * const Z3MapViewRequestFormUserInfoKey = @"zzht.mapview.form.key";
 NSString * const Z3MapViewRequestDetailUserInfoKey = @"zzht.mapview.detail.key";

NSNotificationName const Z3MapViewIdentityFeaturesInGlobalNotification = @"zzht.mapview.identiy.global";
NSNotificationName const Z3MapViewIdentityFeaturesInVisibleNotification = @"zzht.mapview.identiy.visiable";
NSNotificationName const Z3MapViewIdentityFeaturesByMakeRectNotification = @"zzht.mapview.identiy.make.rect";
NSNotificationName const Z3MapViewCancelIdentityFeaturesNotification = @"zzht.mapview.Cancel.identiy.make.rect";
NSNotificationName const Z3MapViewIdentityFeaturesByMakeRectComplicationNotification = @"zzht.mapview.identiy.complication";
NSNotificationName const Z3MapViewIdentityFeaturesComplicationNotification = @"zzht.mapview.identiy.complcation";
NSNotificationName const Z3MapViewIdentityContextDidChangeSelectIndexNotification = @"zzht.mapview.identiy.change.select.index";
NSNotificationName const Z3MapViewIdentityContextDeselectIndexNotification = @"zzht.mapview.identiy.change.deselect.index";
NSNotificationName const Z3HUDIdentityResultDiplayViewDidChangeSelectIndexNotification = @"zzht.identiy.display.view.change.select.index";

//图层控制相关的通知
 NSNotificationName const MasterViewControllerShowDetailViewNotification = @"zzht.master.view.shiw.detail";
 NSNotificationName const ZZCommonMapViewControllerShowLayerFilterViewNotification = @"zzht.mapview.show.filter.view";
 NSNotificationName const Z3MapViewLayerFilterViewControllerSelectIndexNotification = @"zzht.filter.layer.view.change.select.index";
 NSNotificationName const Z3MapViewLayerFilterViewControllerDeselectIndexNotification = @"zzht.filter.layer.view.change.deselect.index";

NSNotificationName const Z3MapViewTapQueryXtdIdentitySuccessNotification = @"zzht.mapview.tap.identity.success";
NSNotificationName const Z3MapViewTapQueryXtdIdentityGraphicFailureNotification = @"zzht.mapview.tap.identity.graphic.failure";
NSNotificationName const Z3TapIdentityResultViewControllerDoneNotification = @"zzht.identity.result.view.done";
NSNotificationName const Z3TapIdentityResultViewControllerCancelNotification = @"zzht.identity.result.view.cancel";
 NSNotificationName const Z3MapViewIdentityContextDidTapAtScreenNotification  = @"zzht.identity.context.tap.screen";;

 NSNotificationName const Z3PipeLeakAnalysisViewControllerQueryLeakPipeNotification = @"zzht.pipe.analysis.query.pipe";
 NSNotificationName const Z3PipeLeakAnalysisViewControllerQueryValueNotification = @"zzht.pipe.analysis.query.value";

 NSNotificationName const Z3PipeLeakAnalysisViewControllerClearNotification = @"zzht.pipe.analysis.clear.results";
//爆管分析-查看设备详情
NSNotificationName const Z3HUDPipeLeakCalloutViewQuickLookDetailNotification = @"zzht.pipe.analysis.quick.look.detail";
//爆管点分析,接口返回成功
NSNotificationName const Z3MapViewQueryLeakPipeXtdAnaylseSuccessNotification = @"zzht.pipe.analysis.success";
NSNotificationName const Z3MapViewQueryLeakPipeXtdAnaylseFailureNotification = @"zzht.pipe.analysis.failure";
//选中爆管点
NSNotificationName const Z3MapViewDidSelectDeviceNotification = @"zzht.pipe.analysis.quick.selected.pipe";
//已取消选中爆管点
NSNotificationName const Z3MapViewDeselectDeviceNotification = @"zzht.pipe.analysis.deselect.pipe";
//二次关阀
NSNotificationName const Z3HUDPipeLeakCalloutViewCloseValveNotification = @"zzht.pipe.analysis.close.valve";
//工程影响范围
NSNotificationName const Z3CloseValveAnalysisViewControllerQueryValveNotification = @"zzht.valve.analysis.choose.valve";;
//查询分析接口
NSNotificationName const Z3CloseValveAnalysisViewControllerAnalyseCloseValveNotification = @"zzht.valve.analysis.close.valve";;

//问题反馈
 NSNotificationName const Z3DevicePickerViewCellTapForSelectDeviceNotification = @"zzht.issue.feedback.select.device";
 NSNotificationName const Z3DevicePickerViewCellTapForReSelectDeviceNotification = @"zzht.issue.feedback.reselect.device";
 NSNotificationName const Z3LocationChoiceCellTapForLocationDeviceNotification = @"zzht.issue.feedback.select.location";
 NSNotificationName const Z3LocationChoiceCellTapForCancelLocationDeviceNotification = @"zzht.issue.feedback.cancel.select.location";
 NSNotificationName const Z3IssueFeedbackViewControllerClearMapViewNotification = @"zzht.issue.feedback.clear.mapview";
NSNotificationName const Z3IssueFeedbackViewControllerFinishMapViewNotification = @"zzht.issue.feedback.finish.mapview";
NSNotificationName const Z3ImagePickerCellStartMarkMapViewNotification = @"zzht.image.picker.mark";

NSNotificationName const ZZCommonMapViewControllerCancelMarkMapViewNotification = @"zzht.mapview.cancel.mark";
NSNotificationName const ZZCommonMapViewControllerFinishMarkMapViewNotification = @"zzht.mapview.finish.mark";

//设备属性相关
NSNotificationName const Z3AGSCalloutViewIPadAddPhotoNotification = @"zzht.device.add.attachment";
NSNotificationName const Z3AGSCalloutViewIPadBrowserPhotoNotification = @"zzht.device.browser.attachment";
#warning 因项目而变化
NSString * const Z3MapViewOnlineFeatureLayerNameKey = @"MWGS";

