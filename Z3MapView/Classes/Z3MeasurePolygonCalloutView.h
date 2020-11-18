//
//  Z3StationCalloutView.h
//  OutWork-SuQian
//
//  Created by ZZHT on 2020/5/11.
//  Copyright © 2020 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3MeasurePolygonCalloutView : UIView
@property (nonatomic,strong,readonly) UILabel *areaNameLabel;
@property (nonatomic,strong,readonly) UILabel *areaValueLabel;
@property (nonatomic,strong,readonly) UILabel *circumferenceNameLabel;
@property (nonatomic,strong,readonly) UILabel *circumferenceValueLabel;

+ (instancetype)calloutView;
@end

NS_ASSUME_NONNULL_END
