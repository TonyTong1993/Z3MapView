//
//  Z3DisplayIdentityResultViewCell.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3DisplayIdentityResultViewCell.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3MapViewHelper.h"
#import "Z3MapView.h"
#import <Masonry/Masonry.h>
#import "Z3Theme.h"
#import "Z3MobileConfig.h"
#import "Z3CoordinateConvertFactory.h"
#import "MBProgressHUD.h"
@interface Z3DisplayIdentityResultViewCell ()
@property (nonatomic,strong) Z3MapViewIdentityResult *identityResult;
@property (strong, nonatomic)  UILabel *materialFlagLabel;
@property (strong, nonatomic)  UILabel *materialLabel;
@property (strong, nonatomic)  UILabel *addressFlagLabel;
@property (strong, nonatomic)  UILabel *addressLabel;
@property (strong, nonatomic)  UIButton *leftFlagBtn;
@property (strong, nonatomic)  UIImageView *leftFlagImageView;
@property (strong, nonatomic)  UIButton *navBtn;
@property (strong, nonatomic)  UIButton *eventBtn;
@property (strong, nonatomic)  UIButton *okBtn;
@end
@implementation Z3DisplayIdentityResultViewCell

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.materialLabel && [keyPath isEqualToString:@"text"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _deviceLabel = [[UILabel alloc] init];
    _deviceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _deviceLabel.font = [UIFont boldSystemFontOfSize:18];
    
    _materialFlagLabel = [[UILabel alloc] init];
    _materialFlagLabel.font = [UIFont systemFontOfSize:15];
    _materialFlagLabel.text = @"材质：";
    _materialLabel = [[UILabel alloc] init];
    _materialLabel.numberOfLines = 0;
    _materialLabel.font = [UIFont systemFontOfSize:15];
    
    _addressFlagLabel = [[UILabel alloc] init];
    _addressFlagLabel.font = [UIFont systemFontOfSize:15];
    _addressFlagLabel.text = @"所在位置：";
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.numberOfLines = 0;
    _addressLabel.font = [UIFont systemFontOfSize:15];
     _leftFlagBtn = [[UIButton alloc] init];
     [_leftFlagBtn setTitle:@"查看详情" forState:UIControlStateNormal];
     [_leftFlagBtn setTitleColor:[UIColor colorWithHexString:@"#007AFF"] forState:UIControlStateNormal];
    _leftFlagBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftFlagBtn addTarget:self action:@selector(onDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftFlagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    _navBtn = [[UIButton alloc] init];
    [_navBtn setTitle:@"位置导航" forState:UIControlStateNormal];
    [_navBtn setTitleColor:[UIColor colorWithHexString:textTintHex] forState:UIControlStateNormal];
    [_navBtn addTarget:self action:@selector(onNaviagtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _eventBtn = [[UIButton alloc] init];
    [_eventBtn setTitle:@"信息采集" forState:UIControlStateNormal];
    [_eventBtn setTitleColor:[UIColor colorWithHexString:textTintHex] forState:UIControlStateNormal];
    [_eventBtn addTarget:self action:@selector(onEventReport:) forControlEvents:UIControlEventTouchUpInside];
    
    _okBtn = [[UIButton alloc] init];
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor colorWithHexString:textTintHex] forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(onOkButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_deviceLabel];
    
    [self.contentView addSubview:_materialFlagLabel];
    [self.contentView addSubview:_materialLabel];
    
    [self.contentView addSubview:_addressFlagLabel];
    [self.contentView addSubview:_addressLabel];
    
    [self.contentView addSubview:_leftFlagBtn];
    [self.contentView addSubview:_leftFlagImageView];
    [self.contentView addSubview:_navBtn];
    [self.contentView addSubview:_eventBtn];
    [self.contentView addSubview:_okBtn];
      
    [self.materialLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:0];
}

-(void)dealloc {
    [self.materialLabel removeObserver:self forKeyPath:@"text"];
}


- (void)updateConstraints {
    [_deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
    }];
    
    if (self.materialLabel.text.length > 0) {
        [_materialFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.deviceLabel.mas_bottom).offset(24);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.width.mas_equalTo(48.0f);
        }];
        [_materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.deviceLabel.mas_bottom).offset(24);
            make.left.mas_equalTo(self.materialFlagLabel.mas_right);
            make.width.mas_equalTo(100.0f);
        }];
        [_addressFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.deviceLabel.mas_bottom).offset(24);
            make.left.mas_equalTo(self.materialLabel.mas_right).offset(8);
            make.width.mas_equalTo(78);
        }];
    }else {
        [_addressFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.deviceLabel.mas_bottom).offset(24);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.width.mas_equalTo(78);
        }];
    }
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deviceLabel.mas_bottom).offset(24);
        make.left.mas_equalTo(self.addressFlagLabel.mas_right);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-24);
    }];
    
    [_leftFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
    }];
    
    [_leftFlagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.leftFlagImageView.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.leftFlagImageView.mas_centerY);
        make.height.mas_equalTo(24);
    }];
    
    NSArray *btns = @[_navBtn,_eventBtn];
    [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.height.mas_equalTo(44.0f);
    }];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
         make.height.mas_equalTo(44.0f);
         make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [super updateConstraints];
}

- (void)setIdentityResult:(Z3MapViewIdentityResult *)result displayType:(NSInteger)displayType{
    _identityResult = result;
    self.deviceLabel.text = [self deviceWithAttributes:result];
    self.materialLabel.text = [self materialWithAttributes:result.attributes];
    self.addressLabel.text = [self addressWithAttributes:result.attributes];
    if (displayType == 1) {
        [_eventBtn setHidden:YES];
        [_navBtn setHidden:YES];
        [_okBtn setHidden:NO];
    }else {
        [_eventBtn setHidden:NO];
        [_navBtn setHidden:NO];
        [_okBtn setHidden:YES];
    }
}

- (NSString *)deviceWithAttributes:(Z3MapViewIdentityResult *)result {
    NSString *device = result.attributes[@"名称"];
    return device;
}

- (NSString *)materialWithAttributes:(NSDictionary *)attribues {
    NSString *material = attribues[@"材质"];
    if (material.length) {
        return [NSString stringWithFormat:@"材质：%@",material];
    }
    return @"";
}

- (NSString *)addressWithAttributes:(NSDictionary *)attribues {
    NSString *address = attribues[@"所在位置"];
    if (address.length > 0) {
        return [NSString stringWithFormat:@"%@",address];
    }
   return @"无";
}

- (void)onNaviagtonClicked:(id)sender {
    if ([Z3MobileConfig shareConfig].coorTransToken) {
        [self.identityResult geometry];
        AGSPoint *point = [[Z3CoordinateConvertFactory factory] labelPointForGeometry:[self.identityResult geometry]];
        [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        [[Z3CoordinateConvertFactory factory] requestReverseAGSPoint:point complication:^(CLLocation * _Nonnull location) {
            [MBProgressHUD hideHUDForView:self.window animated:YES];
            [[Z3MapViewHelper helper] openMapWithDestination:location addressDictionary:@{}];
        }];
    }else {
        CLLocation *location = [self.identityResult destination];
        [[Z3MapViewHelper helper] openMapWithDestination:location addressDictionary:@{}];
    }
}

- (void)onEventReport:(id)sender {
    CLLocation *location =  [_identityResult destination];
    NSMutableDictionary *mattributes = _identityResult.attributes;
    mattributes[@"layerId"] = @(_identityResult.layerId);
    mattributes[@"layerName"] = _identityResult.layerName;
    NSDictionary *data = @{Z3MapViewRequestFormUserInfoKey:location,Z3MapViewRequestDeviceFormNotification:mattributes};
    [self post:Z3MapViewRequestFormNotification userInfo:data];
}

- (void)onOkButton:(id)sender {
    NSMutableDictionary *mattributes = _identityResult.attributes;
    mattributes[@"layerId"] = @(_identityResult.layerId);
    mattributes[@"layerName"] = _identityResult.layerName;
    NSDictionary *data = @{Z3MapViewRequestDeviceUserInfoKey:[mattributes copy]};
    [self post:Z3MapViewRequestDeviceFormNotification userInfo:data];
}

- (void)onDetailClicked:(id)sender {
    NSDictionary *attributes =  [_identityResult attributes];
    NSDictionary *data = @{Z3MapViewRequestDetailUserInfoKey:attributes};
   [self post:Z3MapViewRequestDetailNotification userInfo:data];
}

- (void)post:(NSNotificationName)notificationName userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
}

@end
