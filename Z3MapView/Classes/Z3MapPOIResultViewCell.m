//
//  Z3MapPOIResultViewCell.m
//  AMP
//
//  Created by ZZHT on 2019/8/8.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3MapPOIResultViewCell.h"
#import "Z3MapPOI.h"
#import "Z3Theme.h"
#import "UIColor+Z3.h"
#import <Masonry/Masonry.h>
@interface Z3MapPOIResultViewCell()
@property (nonatomic,strong) UIButton *flagBtn;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) Z3MapPOI *poi;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
@implementation Z3MapPOIResultViewCell

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _flagBtn = [[UIButton alloc] init];
        _flagBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _flagBtn.titleLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:14];
        _flagBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 0);

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:15];
        
        [self.contentView addSubview:_flagBtn];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [_flagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nameLabel.textColor = [UIColor colorWithHex:@"#005bae"];
        self.contentView.backgroundColor = [UIColor colorWithHex:@"#deebfa"];
        [_flagBtn setBackgroundImage:[UIImage imageNamed:@"bg_mark_btn_selected"] forState:UIControlStateNormal];
    }else {
       [_flagBtn setTitleColor:[UIColor colorWithHex:@"#2c78ce"] forState:UIControlStateNormal];
       [_flagBtn setBackgroundImage:[UIImage imageNamed:@"bg_mark_btn_normal"] forState:UIControlStateNormal];
        _nameLabel.textColor = [UIColor colorWithHex:textPrimaryTintHex];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        [_flagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nameLabel.textColor = [UIColor colorWithHex:@"#005bae"];
        self.contentView.backgroundColor = [UIColor colorWithHex:@"#deebfa"];
        [_flagBtn setBackgroundImage:[UIImage imageNamed:@"bg_mark_btn_selected"] forState:UIControlStateNormal];
        
    }else {
        [_flagBtn setTitleColor:[UIColor colorWithHex:@"#2c78ce"] forState:UIControlStateNormal];
        [_flagBtn setBackgroundImage:[UIImage imageNamed:@"bg_mark_btn_normal"] forState:UIControlStateNormal];
        _nameLabel.textColor = [UIColor colorWithHex:textPrimaryTintHex];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
}

- (void)setPOI:(Z3MapPOI *)poi indexPath:(NSIndexPath *)indexPath {
    _poi = poi;
    _indexPath = indexPath;
    [_flagBtn setTitle:[NSString stringWithFormat:@"%ld",indexPath.row+1] forState:UIControlStateNormal];
    _nameLabel.text = poi.address;
    
}

- (void)updateConstraints {
    [_flagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(8);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(31.5);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.flagBtn.mas_right).offset(8);
        make.right.mas_equalTo(self.contentView);
    }];
    
    [super updateConstraints];
}

@end
