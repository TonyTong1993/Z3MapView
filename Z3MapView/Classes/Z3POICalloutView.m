//
//  Z3POICalloutView.m
//  OutWork-SZSL
//
//  Created by 童万华 on 2019/10/14.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import "Z3POICalloutView.h"
#import "UIColor+Z3.h"
#import "Z3Theme.h"
#import "NSString+Chinese.h"
@interface Z3POICalloutView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *attributes;
@property (nonatomic,copy) NSArray *dataSource;
@end
@implementation Z3POICalloutView

+(BOOL)requiresConstraintBasedLayout {
    return YES;
}

static  CGFloat CalloutViewWidth = 240.0f;
static  CGFloat CalloutViewHeight = 150.0f;
+ (instancetype)calloutView {
    CGRect rect = CGRectMake(0, 0, CalloutViewWidth, CalloutViewHeight);
    return [[self alloc] initWithFrame:rect];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initTableView];
    }
    return self;
}


- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 30.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    [self addSubview:_tableView];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(CalloutViewWidth, CalloutViewHeight);
}

- (void)setPOIAttributes:(NSDictionary *)attributes {
    NSArray *datas = attributes[@"attributes"];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in datas) {
        NSString *name = [[dict allKeys] firstObject];
        if ([name isChinese]) {
            [dataSource addObject:dict];
        }
    }
    self.dataSource = [dataSource copy];
    self.attributes = datas;
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.textColor = [UIColor colorWithHex:textTintHex];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:textPrimaryTintHex];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row < self.dataSource.count) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *attributes = self.dataSource[indexPath.row];
        NSArray *allKeys = [attributes allKeys];
        if (allKeys.count) {
            NSString *key = [attributes allKeys][0];
            NSString *value = attributes[key];
            cell.textLabel.text = key;
            cell.detailTextLabel.text = value;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
       
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"查看详情";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= self.dataSource.count) {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectDetailWithAttributes:)]) {
            [_delegate didSelectDetailWithAttributes:self.attributes];
        }
    }
}


@end
