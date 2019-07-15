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
@interface Z3DisplayIdentityResultViewCell ()
@property (nonatomic,strong) Z3MapViewIdentityResult *identityResult;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end
@implementation Z3DisplayIdentityResultViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetailClicked:)];
    [[_deviceLabel superview] addGestureRecognizer:tap];
}

- (void)setIdentityResult:(Z3MapViewIdentityResult *)result {
    _identityResult = result;
    self.deviceLabel.text = [self deviceWithAttributes:result];
    self.materialLabel.text = [self materialWithAttributes:result.attributes];
    self.addressLabel.text = [self addressWithAttributes:result.attributes];
}

- (NSString *)deviceWithAttributes:(Z3MapViewIdentityResult *)result {
    NSString *device = result.attributes[@"名称"];
    return device;
}

- (NSString *)materialWithAttributes:(NSDictionary *)attribues {
    NSString *material = attribues[@"材质"];
    return [NSString stringWithFormat:@"材质：%@",material];
}

- (NSString *)addressWithAttributes:(NSDictionary *)attribues {
    NSString *address = attribues[@"所在位置"];
   return [NSString stringWithFormat:@"所在位置：%@",address];
}

- (IBAction)onNaviagtonClicked:(id)sender {
   CLLocation *location = [self.identityResult destination];
  [[Z3MapViewHelper helper] openMapWithDestination:location addressDictionary:@{}];
}

- (IBAction)onEventReport:(id)sender {
    CLLocation *location =  [_identityResult destination];
    NSDictionary *data = @{Z3MapViewRequestFormUserInfoKey:location};
    [self post:Z3MapViewRequestFormNotification userInfo:data];
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
