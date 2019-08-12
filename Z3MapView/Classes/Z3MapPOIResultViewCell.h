//
//  Z3MapPOIResultViewCell.h
//  AMP
//
//  Created by ZZHT on 2019/8/8.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapPOI;
@interface Z3MapPOIResultViewCell : UITableViewCell
- (void)setPOI:(Z3MapPOI *)poi indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
