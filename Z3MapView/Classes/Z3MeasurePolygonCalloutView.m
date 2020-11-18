//
//  Z3StationCalloutView.m
//  OutWork-SuQian
//
//  Created by ZZHT on 2020/5/11.
//  Copyright © 2020 ZZHT. All rights reserved.
//

#import "Z3MeasurePolygonCalloutView.h"
#import <Masonry/Masonry.h>
#import "Z3Theme.h"
#import "UIColor+Z3.h"
@interface Z3MeasurePolygonCalloutView()
@property (nonatomic,strong) UIView *titleView;
@end
@implementation Z3MeasurePolygonCalloutView
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

static  CGFloat CalloutViewWidth = 160.0f;
static  CGFloat CalloutViewHeight = 25.0f;

+ (instancetype)calloutView {
    CGRect rect = CGRectMake(0, 0, CalloutViewWidth, CalloutViewHeight * 4);
    return [[self alloc] initWithFrame:rect];
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(CalloutViewWidth, CalloutViewHeight);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleView = [UIView new];
        _titleView.backgroundColor = [UIColor whiteColor];
        
        _areaNameLabel = [UILabel new];
        _areaNameLabel.textColor = [UIColor colorWithHex:textTintHex];
        _areaNameLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:themePrimaryFontSize];
        
        _areaValueLabel = [UILabel new];
        _areaValueLabel.textColor = [UIColor colorWithHex:themeColorHex];
        _areaValueLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:themePrimaryFontSize];
        
        _circumferenceNameLabel = [UILabel new];
        _circumferenceNameLabel.textColor = [UIColor colorWithHex:textTintHex];
        _circumferenceNameLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:themePrimaryFontSize];
        
        _circumferenceValueLabel = [UILabel new];
        _circumferenceValueLabel.textColor = [UIColor colorWithHex:themeColorHex];
        _circumferenceValueLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:themePrimaryFontSize];
        
        [self addSubview:_titleView];
        [_titleView addSubview:_areaNameLabel];
        [self addSubview:_areaValueLabel];
        [self addSubview:_circumferenceNameLabel];
        [self addSubview:_circumferenceValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(2);
        make.right.mas_equalTo(self).offset(-2);
        make.height.mas_equalTo(CalloutViewHeight);
    }];
    
    [_areaNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleView.mas_centerY);
        make.left.mas_equalTo(self.titleView.mas_left).offset(2);
    }];
    
    [_areaValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(4);
        make.left.mas_equalTo(self).offset(4);
        make.right.mas_equalTo(self).offset(-2);
    }];
    
    [_circumferenceNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.areaValueLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self).offset(4);
        make.right.mas_equalTo(self).offset(-2);
    }];
    
    [_circumferenceValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circumferenceNameLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self).offset(4);
        make.right.mas_equalTo(self).offset(-2);;
    }];
    
}

@end
