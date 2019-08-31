//
//  Z3HUDPipeLeakCalloutView.m
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3HUDPipeLeakCalloutView.h"
#import "Z3MapView.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3GISMetaBuilder.h"
#import "Z3Theme.h"
#import "UIColor+Z3.h"
#import <Masonry/Masonry.h>
@interface Z3HUDPipeLeakCalloutView()
@property (nonatomic,strong) UIButton *content;
@property (nonatomic,strong) UIButton *closeValve;
@property (nonatomic,copy) Z3MapViewIdentityResult *result;
@end
@implementation Z3HUDPipeLeakCalloutView

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
         self.bounds = CGRectMake(0, 0, PipeLeakCalloutViewWidth, PipeLeakCalloutViewHeight);
        _closeValve = [[UIButton alloc] init];
        _closeValve.titleLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
        [_closeValve setTitleColor:[UIColor colorWithHex:textTintHex] forState:UIControlStateNormal];
        [_closeValve setTitleColor:[UIColor colorWithHex:themeColorHex] forState:UIControlStateHighlighted];
        [_closeValve setTitle:NSLocalizedString(@"ll_accident_twoPipe_txt", @"二次关阀") forState:UIControlStateNormal];
        [_closeValve addTarget:self action:@selector(onClickedValveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeValve];
        
        _content = [[UIButton alloc] init];
        _content.titleLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
        [_content setTitleColor:[UIColor colorWithHex:textTintHex] forState:UIControlStateNormal];
        [_content setTitleColor:[UIColor colorWithHex:themeColorHex] forState:UIControlStateHighlighted];
        [_content setImage:[UIImage imageNamed:@"icon_accessory_arrow_right"] forState:UIControlStateNormal];
        [_content setTitle:NSLocalizedString(@"ll_accident_detail_txt", @"查看详情") forState:UIControlStateNormal];
        _content.translatesAutoresizingMaskIntoConstraints = NO;
        [_content addTarget:self action:@selector(onClickedDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
        _content.titleEdgeInsets = UIEdgeInsetsMake(0, -44, 0, 0);
        _content.imageEdgeInsets = UIEdgeInsetsMake(0, 72, 0, 0);
        [self addSubview:_content];
    }
    return self;
}

static  CGFloat PipeLeakCalloutViewWidth = 100.0f;
static  CGFloat PipeLeakCalloutViewHeight = 32.0f;

- (void)updateConstraints {
    [_closeValve mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(PipeLeakCalloutViewWidth);
    }];
    [_content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(PipeLeakCalloutViewWidth);
    }];
    
    [super updateConstraints];
}

- (CGSize)intrinsicContentSize {
    CGSize size = CGSizeZero;
    if (self.closeValveable) {
        if (_result.layerId == [Z3GISMetaBuilder builder].valveLayerID) {
            size = CGSizeMake(PipeLeakCalloutViewWidth*2, PipeLeakCalloutViewHeight);
        }else {
            size = CGSizeMake(PipeLeakCalloutViewWidth, PipeLeakCalloutViewHeight);
        }
    }else {
       size = CGSizeMake(PipeLeakCalloutViewWidth, PipeLeakCalloutViewHeight);
    }
    
    return size;
}

- (void)setIdentityResult:(Z3MapViewIdentityResult *)result {
    _result = result;
    if (self.closeValveable) {
        if (_result.layerId == [Z3GISMetaBuilder builder].valveLayerID) {
            [_closeValve setHidden:NO];
        }else {
            [_closeValve setHidden:YES];
        }
    }else {
         [_closeValve setHidden:YES];
    }
    
}

- (void)onClickedDetailBtn:(id)sender {
    [self post:Z3HUDPipeLeakCalloutViewQuickLookDetailNotification message:self.result];
}

- (void)onClickedValveBtn:(id)sender {
    NSString *gid = self.result.attributes[@"gid"];
    [self post:Z3HUDPipeLeakCalloutViewCloseValveNotification message:gid];
}

- (void)post:(NSNotificationName)notificationName message:(id)message {
    if (message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:@{@"message":message}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }
}
@end
