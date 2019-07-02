//
//  Z3MapViewSwitchOperationView.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/30.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewSwitchOperationView.h"
#import "Z3MapViewOperationMenuItem.h"
#import "Z3MapViewOperation.h"
@interface Z3MapViewSwitchOperationView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@end
@implementation Z3MapViewSwitchOperationView

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initTableView];
    }
    
    return self;
}

static CGFloat itemHeight = 44.0f;
static NSString *cellReuseIdentifier = @"Z3MapViewOperationMenuItem_ReuseIdentifier";
- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.rowHeight = itemHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[Z3MapViewOperationMenuItem class] forCellReuseIdentifier:cellReuseIdentifier];
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (CGSize)intrinsicContentSize {
    CGFloat width = 140.0f;
    CGFloat height = itemHeight*self.dataSource.count;
    return CGSizeMake(width, height);
}

- (void)updateConstraints {
   [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [super updateConstraints];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Z3MapViewOperationMenuItem *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (nil == cell) {
        cell = [[Z3MapViewOperationMenuItem alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:nil];
    }
    Z3MapViewOperation *operation = _dataSource[indexPath.row];
    cell.textLabel.text = operation.name;
    cell.imageView.image = [UIImage imageNamed:operation.icon];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Z3MapViewOperation *operation = _dataSource[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(operationViewDidSelectedOperation:)]) {
        [_delegate operationViewDidSelectedOperation:operation];
    }
}

@end
