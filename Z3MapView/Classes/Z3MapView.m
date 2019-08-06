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

 NSNotificationName const Z3PipeLeakAnalysisViewControllerQueryLeakPipeNotification = @"zzht.pipe.analysis.query.pipe";;
 NSNotificationName const Z3PipeLeakAnalysisViewControllerQueryValueNotification = @"zzht.pipe.analysis.query.value";
 NSNotificationName const Z3PipeLeakAnalysisViewControllerClearNotification = @"zzht.pipe.analysis.clear.results";
NSNotificationName const Z3HUDPipeLeakCalloutViewQuickLookDetailNotification = @"zzht.pipe.analysis.quick.look.detail";
NSNotificationName const Z3MapViewQueryLeakPipeXtdSelectedIssueLocationNotification = @"zzht.pipe.analysis.quick.selected.pipe";
//已取消选中爆管点
NSNotificationName const Z3MapViewQueryLeakPipeXtdDeselectIssueLocationNotification = @"zzht.pipe.analysis.deselect.pipe";
#warning 因项目而变化
NSString * const Z3MapViewOnlineFeatureLayerNameKey = @"GWDT MWS SL";

