//
//  Z3SelectOption.h
//  AMP
//
//  Created by ZZHT on 2019/9/16.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Z3SelectionOption <NSObject>
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *alias;
@end

NS_ASSUME_NONNULL_END
