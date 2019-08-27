//
//  Z3AGSCalloutViewIPad.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/21.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3AGSCalloutViewIPad.h"
#import "Z3FeatureAttributesDisplayView.h"
#import "Z3MobileConfig.h"
#import "Z3MapView.h"
@interface Z3AGSCalloutViewIPad()
@property (nonatomic,strong) Z3FeatureAttributesDisplayView *displayView;
@property (nonatomic,strong) UIButton *takePhotoBtn;
@property (nonatomic,strong) UIButton *photoBrowserBtn;
@end
@implementation Z3AGSCalloutViewIPad

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

+ (instancetype)calloutView {
    return [[self alloc] init];
}


static  CGFloat CalloutViewWidth = 240.0f;
static  CGFloat CalloutViewHeight = 335.0f;
- (instancetype)init {
    self = [super init];
    if (self) {
        _displayView = [[Z3FeatureAttributesDisplayView alloc] initWithFrame:CGRectZero];
        _displayView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_displayView];
        if (![Z3MobileConfig shareConfig].offlineLogin) {
            _takePhotoBtn = [[UIButton alloc] init];
            [_takePhotoBtn setTitle:NSLocalizedString(@"Take Photo", @"拍照") forState:UIControlStateNormal];
            [_takePhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _takePhotoBtn.titleLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
            _takePhotoBtn.layer.cornerRadius = 5.0f;
            _takePhotoBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [_takePhotoBtn setBackgroundColor:[UIColor colorWithHex:leftNavBarColorHex]];
            [_takePhotoBtn addTarget:self action:@selector(onTakePhotoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_takePhotoBtn];
            
            _photoBrowserBtn = [[UIButton alloc] init];
            [_photoBrowserBtn setTitle:NSLocalizedString(@"Browser Photo", @"浏览") forState:UIControlStateNormal];
            [_photoBrowserBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _photoBrowserBtn.titleLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
            [_photoBrowserBtn setBackgroundColor:[UIColor colorWithHex:leftNavBarColorHex]];
            _photoBrowserBtn.layer.cornerRadius = 5.0f;
            _photoBrowserBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [_photoBrowserBtn addTarget:self action:@selector(onBrowserPhotoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_photoBrowserBtn];
        }
        
    }
    return self;
}


- (CGSize)intrinsicContentSize {
    return CGSizeMake(CalloutViewWidth, CalloutViewHeight);
}

- (void)updateConstraints {
    if ([Z3MobileConfig shareConfig].offlineLogin) {
        [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(4);
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-4);
        }];
    }else {
        [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(4);
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-60);
        }];
        
        NSArray *items = @[_takePhotoBtn,_photoBrowserBtn];
        [items mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-16);
            make.height.mas_equalTo(28);
        }];
        
        [items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:12 tailSpacing:12];
    }
    
    [super updateConstraints];
}

- (void)setIdentityResult:(Z3MapViewIdentityResult *)result {
    [_displayView setIdentityResult:result];
}

- (void)setFeature:(AGSArcGISFeature *)featrue {
    [_displayView setFeature:featrue];
}

- (void)onTakePhotoBtnClicked:(id)sender {
    [self post:Z3AGSCalloutViewIPadAddPhotoNotification message:_displayView.result];
}

- (void)onBrowserPhotoBtnClicked:(id)sender {
      [self post:Z3AGSCalloutViewIPadBrowserPhotoNotification message:_displayView.result];
}

- (void)post:(NSNotificationName)notificationName message:(id)message {
    if (message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:@{@"message":message}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }
}

@end
