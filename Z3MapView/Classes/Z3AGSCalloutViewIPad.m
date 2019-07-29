//
//  Z3AGSCalloutViewIPad.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/21.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3AGSCalloutViewIPad.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3MobileConfig.h"
@interface Z3AGSCalloutViewIPad()<UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSDictionary *attributes;
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
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(CalloutViewWidth, CalloutViewHeight);
}

- (void)setIdentityAttributes:(NSDictionary *)attributes {
    _attributes = attributes;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attributes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
   NSDictionary *fieldAliases = [Z3MobileConfig shareConfig].fieldAliases;
   NSString *key = [self.attributes allKeys][indexPath.row];
   NSString *value = self.attributes[key];
   cell.textLabel.text = fieldAliases[key];
   cell.detailTextLabel.text = value;
   return cell;
}

@end
