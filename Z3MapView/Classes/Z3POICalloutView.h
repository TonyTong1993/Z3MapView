//
//  Z3POICalloutView.h
//  OutWork-SZSL
//
//  Created by 童万华 on 2019/10/14.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol Z3POICalloutViewDelegate <NSObject>

- (void)didSelectDetailWithAttributes:(NSArray *)attributes;

@end
@interface Z3POICalloutView : UIView
+ (instancetype)calloutView;
@property (nonatomic,weak) id<Z3POICalloutViewDelegate> delegate;
- (void)setPOIAttributes:(NSDictionary *)attributes;
@end

NS_ASSUME_NONNULL_END
