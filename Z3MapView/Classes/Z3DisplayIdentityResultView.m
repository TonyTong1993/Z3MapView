//
//  Z3DisplayIdentityResultView.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3DisplayIdentityResultView.h"
#import "Z3DisplayIdentityResultViewCell.h"
@interface Z3DisplayIdentityResultView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,copy) NSArray *dataSource;
@property (nonatomic,assign) NSInteger dispalyType;
@end
@implementation Z3DisplayIdentityResultView
static NSString *Z3DisplayIdentityResultViewCell_reuseIdentifier = @"Z3DisplayIdentityResultViewCell_reuseIdentifier";
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithDataSource:(NSArray *)dataSource {
    self = [self init];
    if (self) {
        self.dataSource = dataSource;
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initCollectionView];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)setSelectItem:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)setDisplayType:(NSInteger)type {
    _dispalyType = type;
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[Z3DisplayIdentityResultViewCell class] forCellWithReuseIdentifier:Z3DisplayIdentityResultViewCell_reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];

}

- (void)updateConstraints {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSString *hft = @"H:|-0-[_collectionView]-0-|";
    [results addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:hft options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    NSString *vft = @"V:|-0-[_collectionView]-0-|";
    [results addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vft options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:results];
    [super updateConstraints];
}

#pragma mark - control item size and space
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat height = self.collectionView.bounds.size.height;
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Z3DisplayIdentityResultViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Z3DisplayIdentityResultViewCell_reuseIdentifier forIndexPath:indexPath];
    Z3MapViewIdentityResult *result = self.dataSource[indexPath.row];
    [cell setIdentityResult:result indexPath:indexPath displayType:_dispalyType];
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat width = self.bounds.size.width;
    NSUInteger index = offset.x/width;
    if (_delegate && [_delegate respondsToSelector:@selector(displayIdentityViewDidScrollToPageIndex:)]) {
        [_delegate displayIdentityViewDidScrollToPageIndex:index];
    }
    
}
@end
