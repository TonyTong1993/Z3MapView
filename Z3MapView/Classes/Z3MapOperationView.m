//
//  mapOperationView.m
//  OutWork
//
//  Created by ZZHT on 2018/7/17.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "Z3MapOperationView.h"
#import "Z3MapOperationViewCell.h"
#import "Z3MapViewOperation.h"
#import <Masonry/Masonry.h>
#import "Z3Theme.h"
#import "UIColor+Z3.h"
@interface Z3MapOperationView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,weak) id<Z3MapViewOperationDelegate> delegate;
@end
#define VIEW_WIDTH 140
#define ROW_HEIGHT 44
@implementation Z3MapOperationView
@synthesize items = _items;
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (instancetype)initWithOperationItems:(NSArray *)items withDelegate:(id<Z3MapViewOperationDelegate>)delegate {
    self = [super init];
    if (self) {
        _items = items;
        _delegate = delegate;
        CGRect frame = CGRectMake(0, 0, VIEW_WIDTH, ROW_HEIGHT*items.count+4);
        self.bounds = frame;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    self.tableView = tableView;
}
#pragma mark - layout constraints
- (void)updateConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Z3MapOperationViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (nil == cell) {
        cell = [[Z3MapOperationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
    }
    Z3MapViewOperation *operation = _items[indexPath.row];
    cell.textLabel.text = operation.name;
    cell.imageView.image = [UIImage imageNamed:operation.icon];
    cell.textLabel.textColor = [UIColor colorWithHex:themeColorHex];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Z3MapViewOperation *operation = _items[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(mapOperationView:didSelectedOperation:)]) {
        [_delegate mapOperationView:self didSelectedOperation:operation];
    }
}
@end
