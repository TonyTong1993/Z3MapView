//
//  Z3FeatureAttributesDisplayView.m
//  AMP
//
//  Created by ZZHT on 2019/8/5.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3FeatureAttributesDisplayView.h"
#import "Z3MobileConfig.h"
#import "Z3MapViewIdentityResult.h"
#import "Z3GISMetaQuery.h"
#import "Z3FeatureLayer.h"
#import "Z3FeatureLayerProperty.h"
#import "NSString+Chinese.h"
#import <Masonry/Masonry.h>
#import "Z3Theme.h"
#import "UIColor+Z3.h"
#import <ArcGIS/ArcGIS.h>
#import "DateUtil.h"
@interface Z3FeatureAttributesDisplayView()<UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *dataSource;
@end
@implementation Z3FeatureAttributesDisplayView
@synthesize result = _result;
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initTableView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_tableView];
}

- (void)updateConstraints {
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [super updateConstraints];
}

- (void)setIdentityResult:(Z3MapViewIdentityResult *)result {
    _result = result;
      __block NSMutableArray *properties = [[NSMutableArray alloc] init];
    if ([result respondsToSelector:@selector(layerName)]) {
        if (result.layerName) {
            Z3FeatureLayer *feature = [[Z3GISMetaQuery querier] aomen_buildDeviceMetaWithTargetLayerName:result.layerName targetLayerId:result.layerId];
            NSArray *fields = feature.fields;
            [fields enumerateObjectsUsingBlock:^(Z3FeatureLayerProperty *property, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([property.alias isChinese]) {
                    property.displayValue = result.attributes[property.name];
                    [properties addObject:property];
                }
            }];
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"findex" ascending:YES];
            self.dataSource = [properties sortedArrayUsingDescriptors:@[sort]];
        }else {
            NSDictionary *attributes = result.attributes;
            NSArray *fields =  [Z3MobileConfig shareConfig].fields;
            [fields enumerateObjectsUsingBlock:^(NSDictionary *field, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *name = field[@"name"];
                NSString *alias = field[@"alias"];
                if ([alias isChinese]) {
                    Z3FeatureLayerProperty *property = [[Z3FeatureLayerProperty alloc] init];
                    property.alias = alias;
                    property.displayValue = attributes[name];
                    [properties addObject:property];
                }
            }];
            self.dataSource = properties;
        }
    }else {
        AGSArcGISFeature *feature = (AGSArcGISFeature *)result;
        NSArray<AGSField*> *fields = feature.featureTable.fields;
        NSDictionary *attributes = result.attributes;
        __block NSMutableArray *properties = [[NSMutableArray alloc] init];
        [fields enumerateObjectsUsingBlock:^(AGSField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *name = obj.name;
            NSString *alias = obj.alias;
            if ([alias isChinese]) {
                Z3FeatureLayerProperty *property = [[Z3FeatureLayerProperty alloc] init];
                property.alias = alias;
                id value = attributes[name];
                if ([value isKindOfClass:[NSDate class]]) {
                    value = [DateUtil stringFromDateDay:value];
                }else if ([value isKindOfClass:[NSNull class]]) {
                    value = @"";
                }else if ([value isKindOfClass:[NSNumber class]]) {
                    value = [value stringValue];
                }
                property.displayValue = [value description];
                [properties addObject:property];
            }
        }];
          self.dataSource = properties;
    }
    
    
     [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    Z3FeatureLayerProperty *property = self.dataSource[indexPath.row];
    cell.textLabel.text = property.alias;
    cell.textLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:13];
    cell.detailTextLabel.text = [property.displayValue description];
    cell.detailTextLabel.font = [UIFont fontWithName:[Z3Theme themeFontFamilyName] size:13];
    return cell;
}




@end
