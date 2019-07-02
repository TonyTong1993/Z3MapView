//
//  Z3MapViewOperationMenuItem.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/30.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewOperationMenuItem.h"

@implementation Z3MapViewOperationMenuItem

@synthesize textLabel = _textLabel,imageView = _imageView;
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.layer.cornerRadius = 4.0f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderWidth = 1.0f;
        [self configure];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    CGFloat padding = 4.0f;
    CGFloat startX = frame.origin.x + padding;
    CGFloat startY = frame.origin.y + padding;
    CGFloat width = frame.size.width - padding*2;
    CGFloat height = frame.size.height- padding;
    CGRect rect = CGRectMake(startX, startY, width, height);
    [super setFrame:rect];
}

#pragma mark - @properties
- (UILabel *)textLabel {
    if (_textLabel) return _textLabel;
    _textLabel = [[UILabel alloc] init];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    return _textLabel;
}
- (UIImageView *)imageView {
    if (_imageView) return _imageView;
    _imageView = [[UIImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return _imageView;
}
#pragma mark - configure
- (void)configure {
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addConstraints:[self layoutConstraints]];
}
#pragma mark - layoutConstraints
- (NSArray *)layoutConstraints {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [self.textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.textLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [results addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[_textLabel]-(margin)-|" options:NSLayoutFormatAlignAllLastBaseline metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(17),@"margin", nil] views:NSDictionaryOfVariableBindings(_textLabel)]];
    return results;
}
- (void)updateConstraints {
    NSDictionary *views = @{@"image":_imageView,@"label":_textLabel};
    NSMutableArray *resuts = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[image]-[label]-|" options:0 metrics:nil views:views]];
    [resuts addObject:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [resuts addObject:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24]];
    [resuts addObject:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24]];
    [self.contentView addConstraints:resuts];
    [super updateConstraints];
}

@end
