//
//  Z3AGSPopupFactory.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/20.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3AGSPopupFactory.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3MapViewIdentityResult.h"
#import "Z3GISMetaBuilder.h"
@implementation Z3AGSPopupFactory

+ (instancetype)factory {
    return [[super alloc] init];
}

- (AGSPopup *)buildPopupWithIdentityResult:(Z3MapViewIdentityResult *)result graphic:(AGSGraphic *)graphic{
    NSDictionary *deviceInfo = [[Z3GISMetaBuilder builder] buildDeviceMetaWithTargetLayerName:result.layerName targetLayerId:result.layerId];
    NSInteger type = [deviceInfo[@"disptype"] intValue];
    AGSPopupDefinition *popupDefinition = [AGSPopupDefinition popupDefinition];
    NSArray *fields = [self popupFieldsWithAttribute:result.attributes];
    popupDefinition.fields = fields;
    AGSPopup *popup = [[AGSPopup alloc] initWithGeoElement:graphic popupDefinition:popupDefinition];
   return popup;
}

- (NSArray *)popupFieldsWithAttribute:(NSDictionary *)attributes {
    NSMutableArray *fields = [NSMutableArray array];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        AGSPopupField *field = [[AGSPopupField alloc] init];
        field.fieldName = key;
        field.label = obj;
        field.editable = NO;
        field.stringFieldOption = AGSPopupStringFieldOptionSingleLine;
        [fields addObject:field];
    }];
    return fields;
}

- (NSArray *)buildPopupsWithIdentityResults:(NSArray *)results graphics:(NSArray *)graphics {
    NSInteger count = results.count;
    NSAssert(count == graphics.count, @"not match count");
    NSMutableArray *popups = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        AGSGraphic *graphic = graphics[i];
        Z3MapViewIdentityResult *result = results[i];
        AGSPopup *popup = [self buildPopupWithIdentityResult:result graphic:graphic];
        [popups addObject:popup];
        
    }
    return popups;
}
@end
