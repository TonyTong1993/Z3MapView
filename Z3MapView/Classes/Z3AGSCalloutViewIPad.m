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
@interface Z3AGSCalloutViewIPad()
@property (nonatomic,strong) Z3FeatureAttributesDisplayView *displayView;
@end
@implementation Z3AGSCalloutViewIPad

+ (instancetype)calloutView {
    return [[self alloc] init];
}
static  CGFloat CalloutViewWidth = 320.0f;
static  CGFloat CalloutViewHeight = 568.0f;
- (instancetype)init {
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, CalloutViewWidth, CalloutViewHeight);
        _displayView = [[Z3FeatureAttributesDisplayView alloc] initWithFrame:self.bounds];
        [self addSubview:_displayView];
    }
    return self;
}


- (CGSize)intrinsicContentSize {
    return CGSizeMake(CalloutViewWidth, CalloutViewHeight);
}

- (void)setIdentityResult:(Z3MapViewIdentityResult *)result {
    [_displayView setIdentityResult:result];
}



@end
