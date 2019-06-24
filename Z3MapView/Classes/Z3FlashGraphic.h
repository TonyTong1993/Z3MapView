//
//  Z3FlashGraphic.h
//  OutWork
//
//  Created by 童万华 on 2019/6/15.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3FlashGraphic : AGSGraphic
@property (nullable, nonatomic, strong, readwrite) AGSSymbol *normalSymbol;
@property (nullable, nonatomic, strong, readwrite) AGSSymbol *selectedSymbol;
@end

NS_ASSUME_NONNULL_END
