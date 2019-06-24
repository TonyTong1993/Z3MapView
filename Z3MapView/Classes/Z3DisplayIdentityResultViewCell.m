//
//  Z3DisplayIdentityResultViewCell.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3DisplayIdentityResultViewCell.h"
#import "Z3MapViewIdentityResult.h"
@interface Z3DisplayIdentityResultViewCell ()
@property (nonatomic,strong) Z3MapViewIdentityResult *identityResult;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end
@implementation Z3DisplayIdentityResultViewCell

- (void)setIdentityResult:(Z3MapViewIdentityResult *)result {
    _identityResult = result;
   
    self.deviceLabel.text = [self deviceWithAttributes:result];
    self.materialLabel.text = [self materialWithAttributes:result.attributes];
    self.addressLabel.text = [self addressWithAttributes:result.attributes];
}

- (NSString *)deviceWithAttributes:(Z3MapViewIdentityResult *)result {
    NSString *device = @"";
     NSString *flag = [[result.layerName componentsSeparatedByString:@"_"] lastObject];
    if ([flag isEqualToString:@"nod"]) {
        device = result.attributes[@"点类型"];
    }else {
        device = result.attributes[@"类型"];
    }
    return device;
}

- (NSString *)materialWithAttributes:(NSDictionary *)attribues {
    NSString *material = attribues[@"材质"];
    if (material.length) {
        return [NSString stringWithFormat:@"材质：%@",material];
    }
    return nil;
}

- (NSString *)addressWithAttributes:(NSDictionary *)attribues {
    NSString *address = attribues[@"所在位置"];
   return [NSString stringWithFormat:@"所在位置：%@",address];
}

@end
