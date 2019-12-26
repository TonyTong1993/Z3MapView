//
//  Z3StatisticsConfigurationFacotry.m
//  AMP
//
//  Created by ZZHT on 2019/9/4.
//  Copyright © 2019年 ZZHT. All rights reserved.
//

#import "Z3StatisticsConfigurationFacotry.h"
#import "Z3OneStatistics.h"
#import "Z3StatisticsField.h"
#import "YYCache.h"
#import "UIApplication+YYAdd.h"
#import "NSDictionary+YYAdd.h"
@implementation Z3StatisticsConfigurationFacotry
 static NSString *cachePath = @"zzht.com.data.json";
 static NSString *fileName = @"fieldAliases";
 static NSString *statistic = @"statistic";
+ (instancetype)factory {
    YYCache *cache = [YYCache cacheWithName:cachePath];
    if (![cache containsObjectForKey:fileName]) {
        NSString *path = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"DataJson-%@.json",fileName]];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSDictionary *json = [NSDictionary dictionaryWithPlistData:data];
        [cache setObject:json forKey:fileName];
    }
    
    if (![cache containsObjectForKey:statistic]) {
        NSString *path = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"DataJson-%@.json",statistic]];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [cache setObject:json forKey:statistic];
        }
    }
    return [[super alloc] init];
}

- (NSString *)pipeDiameterName {
    YYCache *cache = [YYCache cacheWithName:cachePath];
    if ([cache containsObjectForKey:fileName]) {
       NSDictionary *dict = (NSDictionary *)[cache objectForKey:fileName];
       NSString *cal = [dict valueForKey:@"cal"];
        return cal;
    }
    return @"";
}

- (NSString *)materialName {
    YYCache *cache = [YYCache cacheWithName:cachePath];
    if ([cache containsObjectForKey:fileName]) {
        NSDictionary *dict = (NSDictionary *)[cache objectForKey:fileName];
        NSString *vai = [dict valueForKey:@"material"];
        return vai;
    }
    return @"";
}

- (NSString *)lengthName {
    YYCache *cache = [YYCache cacheWithName:cachePath];
    if ([cache containsObjectForKey:fileName]) {
        NSDictionary *dict = (NSDictionary *)[cache objectForKey:fileName];
        NSString *vai = [dict valueForKey:@"length"];
        return vai;
    }
    return @"";
}

- (NSString *)roadName {
    YYCache *cache = [YYCache cacheWithName:cachePath];
    if ([cache containsObjectForKey:fileName]) {
        NSDictionary *dict = (NSDictionary *)[cache objectForKey:fileName];
        NSString *vai = [dict valueForKey:@"roadName"];
        return vai;
    }
    return @"";
}

- (NSString *)cityName {
    YYCache *cache = [YYCache cacheWithName:cachePath];
    if ([cache containsObjectForKey:fileName]) {
        NSDictionary *dict = (NSDictionary *)[cache objectForKey:fileName];
        NSString *vai = [dict valueForKey:@"cityName"];
        return vai;
    }
    return @"";
}

- (NSString *)jsName {
    YYCache *cache = [YYCache cacheWithName:cachePath];
    if ([cache containsObjectForKey:fileName]) {
        NSDictionary *dict = (NSDictionary *)[cache objectForKey:fileName];
        NSString *vai = [dict valueForKey:@"JS"];
        return vai;
    }
    return @"";
}





@end
