//
//  Z3MapOperationBuilder.m
//  OutWork
//
//  Created by 童万华 on 2019/6/27.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import "Z3MapViewOperationBuilder.h"
#import "Z3MapViewOperation.h"
@implementation Z3MapViewOperationBuilder
+ (instancetype)builder {
    return [[super alloc] init];
}

- (NSMutableArray *)buildOperations {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"map_btn" ofType:@"plist"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError * __autoreleasing error = nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:0 error:&error];
    if (error) {
        NSAssert(false, @"failure to parser map btns");
    }
    NSMutableArray *marry = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        Z3MapViewOperation *operation = [[Z3MapViewOperation alloc] init];
         operation.name = dic[@"name"];
         operation.icon = dic[@"icon"];
         operation.className = dic[@"command"];
        [marry addObject:operation];
    }
    
    return marry;
}

- (Z3MapViewOperation *)buildSimulatedLocationOpertaion {
    Z3MapViewOperation *operation = [[Z3MapViewOperation alloc] init];
    operation.name = @"模拟线路";
    operation.icon = @"btn_mainmenu_measure_length";
    operation.className = @"Z3BuildSimulatedLocationDataSourceXtd";
    return operation;
}
@end
