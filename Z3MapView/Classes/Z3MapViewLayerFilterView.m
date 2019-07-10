//
//  MapLayerFilterView.m
//  OutWork
//
//  Created by ZZHT on 2018/7/17.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "Z3MapViewLayerFilterView.h"
#import <Masonry/Masonry.h>
#import "Z3MapViewOperation.h"
@interface Z3MapViewLayerFilterView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) id<Z3MapViewOperationDelegate> delegate;
@property (nonatomic,weak) UITableView *tableView;
@end
@implementation Z3MapViewLayerFilterView
#define ROW_HEIGHT 44
@synthesize layerDataSource = _layerDataSource;
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (instancetype)initWithLayerDataSource:(NSArray *)dataSource andDelegate:(id<Z3MapViewOperationDelegate>)delegate {
    self = [super init];
    if (self) {
        _layerDataSource = dataSource;
        _delegate = delegate;
        [self setupSubView];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenW, ROW_HEIGHT*self.layerDataSource.count);
}
#pragma mark - layout constraints
- (void)updateConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [super updateConstraints];
}
- (void)setupSubView  {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.rowHeight = ROW_HEIGHT;
    tableView.scrollEnabled = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    self.tableView = tableView;
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.layerDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Z3MapViewOperation *operation = _layerDataSource[indexPath.row];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
        UISwitch *switchAccessView = [[UISwitch alloc] init];
        [switchAccessView setOn:operation.visible];
        [switchAccessView addTarget:self action:@selector(notifySwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchAccessView;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = operation.name;
    cell.imageView.image = [UIImage imageNamed:@"btn_map_location"];
    return cell; 
}
#pragma mark - notify custom switch value changed
- (void)notifySwitchValueChanged:(UISwitch *)sender {
     UIResponder *responder = [sender nextResponder];
    if (![responder isKindOfClass:[UITableViewCell class]]) {
        return;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)responder];
    if (_delegate && [_delegate respondsToSelector:@selector(layerFilterView:didChangeLayerStateAtIndex:layerDisplayState:)]) {
        [self.delegate layerFilterView:self didChangeLayerStateAtIndex:indexPath.row layerDisplayState:sender.on];
    }
}
@end
