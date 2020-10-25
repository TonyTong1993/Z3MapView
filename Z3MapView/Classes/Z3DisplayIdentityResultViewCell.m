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
#import "Z3GISMetaQuery.h"
#import "Z3FeatureCollectionLayer.h"
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
    _addressFlagLabel.text = @"所在道路：";
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.numberOfLines = 0;
    _addressLabel.font = [UIFont systemFontOfSize:15];
     _leftFlagBtn = [[UIButton alloc] init];
     [_leftFlagBtn setTitle:@"详情" forState:UIControlStateNormal];
     [_leftFlagBtn setTitleColor:[UIColor colorWithHexString:@"#007AFF"] forState:UIControlStateNormal];
    _leftFlagBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftFlagBtn addTarget:self action:@selector(onDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftFlagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    _navBtn = [[UIButton alloc] init];
    [_navBtn setTitle:@"位置导航" forState:UIControlStateNormal];
    [_navBtn setTitleColor:[UIColor colorWithHexString:textTintHex] forState:UIControlStateNormal];
    [_navBtn addTarget:self action:@selector(onNaviagtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _eventBtn = [[UIButton alloc] init];
    [_eventBtn setTitle:@"事件上报" forState:UIControlStateNormal];
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

- (void)setIdentityResult:(Z3MapViewIdentityResult *)result
                indexPath:(NSIndexPath *)indexPath
              displayType:(NSInteger)displayType datasourceCount:(NSInteger)totalCount{
    _identityResult = result;
    NSString *title = @"";
    NSString *material = @"";
    NSArray *addressArray = [self addressWithAttributes:result.attributes];
    NSString *address = addressArray[1];
    NSString *addressTitle = addressArray[0];
    NSString *dno = result.attributes[@"dno"];
    NSArray *allKeys = [result.attributes allKeys];
    Z3FeatureLayer *featureLayer = [[Z3GISMetaQuery querier] layerIdWithDNO:dno];
    if (featureLayer.geotype == 0) {
        title = [NSString stringWithFormat:@"%ld：%@", totalCount - 1 -  indexPath.row + 1,[self deviceWithAttributes:result]];
        //title = [NSString stringWithFormat:@"%ld：%@",indexPath.row+1,[self deviceWithAttributes:result]];
        material = [self materialWithAttributes:result.attributes];
        if (address.length) {
            _addressFlagLabel.text = addressTitle;
        }else {
            if ([allKeys containsObject:@"管径"]) {
                _addressFlagLabel.text = @"管径：";
                address = result.attributes[@"管径"];
            }else {
                _addressFlagLabel.text = @"";
                address = @"";
            }
        }
        _materialFlagLabel.text = @"材质：";
    }else if (featureLayer.geotype == 1) {
        title = [NSString stringWithFormat:@"%ld：%@",indexPath.row+1,[self deviceWithAttributes:result]];
        material = result.attributes[@"设备类型"];
        _materialFlagLabel.text = @"类型：";
        _addressFlagLabel.text = addressTitle;
    }
    self.deviceLabel.text = title;
    self.materialLabel.text = material;
    self.addressLabel.text = address;
    switch (displayType) {
        case 0:
        {
            [_eventBtn setHidden:NO];
            [_navBtn setHidden:NO];
            [_okBtn setHidden:YES];
        }
            break;
        case 1:
        {
            [_eventBtn setHidden:YES];
            [_navBtn setHidden:YES];
            [_okBtn setHidden:NO];
        }
            break;
        case 2:
        {
            [_eventBtn setHidden:YES];
            [_navBtn setHidden:YES];
            [_okBtn setHidden:YES];
        }
            break;
        default:
            break;
    }
}

/*
 *1
 */
- (NSString *)deviceWithAttributes:(Z3MapViewIdentityResult *)result {
    NSDictionary *attributes = result.attributes;
    NSString *device = @"";
    if ([attributes.allKeys containsObject:@"名称"] && [attributes[@"名称"] length]) {
        device = attributes[@"名称"];
    }else if([attributes.allKeys containsObject:@"组分类型"]) {
        device = attributes[@"组分类型"];
    }else {
         device = @"管段";
    }
    return device;
}

- (NSString *)materialWithAttributes:(NSDictionary *)attribues {
    NSString *material = attribues[@"材质"];
    if (material.length) {
        return material;
    }
    return @"";
}

- (NSArray *)addressWithAttributes:(NSDictionary *)attribues {
     NSString *key = @"";
     NSString *address = @"";
    if ([attribues.allKeys containsObject:@"所在道路"]) {
        address = attribues[@"所在道路"];
        key = @"所在道路";
    }else if([attribues.allKeys containsObject:@"所在位置"]) {
        address = attribues[@"所在位置"];
        key = @"所在位置";
    }else {
        key = @"所在位置";
    }
    //TODO:目前只有宿迁和苏州水利这个地方不一样
    return @[key,address];
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
    NSDictionary *data = @{Z3MapViewRequestFormUserInfoKey:location,Z3MapViewRequestDeviceUserInfoKey:mattributes};
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
