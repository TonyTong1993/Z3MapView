//
//  Z3MapViewCenterPropertyView.m
//  AMP
//
//  Created by ZZHT on 2019/7/17.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapViewCenterPropertyView.h"
#import "Z3Theme.h"
#import "UIColor+Z3.h"
#import <Masonry/Masonry.h>
@interface Z3MapViewCenterPropertyView()
@property (nonatomic,strong) UIStackView *stackView;
@property (nonatomic,strong) UILabel *xFlag;
@property (nonatomic,strong) UILabel *xLabel;
@property (nonatomic,strong) UILabel *yFlag;
@property (nonatomic,strong) UILabel *yLabel;
@end
@implementation Z3MapViewCenterPropertyView

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)init {
    if (self == [super init]) {
        _stackView = [[UIStackView alloc] init];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
        _xLabel = [UILabel new];
        _xLabel.text = @"229822.987";
        
        _xLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
        _yLabel = [UILabel new];
        _yLabel.text = @"229822.987";
        _yLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
        _xFlag = [UILabel new];
        _xFlag.text = @"X";
        _xFlag.textAlignment = NSTextAlignmentCenter;
        _xFlag.textColor = [UIColor whiteColor];
        _xFlag.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
        _xFlag.backgroundColor = [UIColor colorWithHex:themeColorHex];
        _xFlag.layer.cornerRadius = 2.0f;
        _xFlag.layer.masksToBounds = YES;
        
        _yFlag = [UILabel new];
        _yFlag.text = @"Y";
        _yFlag.textColor = [UIColor whiteColor];
        _yFlag.textAlignment = NSTextAlignmentCenter;
        _yFlag.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
        _yFlag.backgroundColor = [UIColor colorWithHex:themeColorHex];
        _yFlag.layer.cornerRadius = 2.0f;
        _yFlag.layer.masksToBounds = YES;
    
        [_stackView addArrangedSubview:_xFlag];
        [_stackView addArrangedSubview:_xLabel];
        [_stackView addArrangedSubview:_yFlag];
        [_stackView addArrangedSubview:_yLabel];
        [self addSubview:_stackView];
    }
    return self;
}

- (void)updateConstraints {
    [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_xLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(78);
    }];
    
    [_yLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(78);
    }];
    
    [_xFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
    }];
    
    [_yFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
    }];
    
    [super updateConstraints];
}

- (void)updateX:(double)x Y:(double)y {
    NSString *xtext = [NSString stringWithFormat:@"%.3f",x];
    NSString *ytext = [NSString stringWithFormat:@"%.3f",y];
    _xLabel.text = xtext;
    _yLabel.text = ytext;
}




@end
