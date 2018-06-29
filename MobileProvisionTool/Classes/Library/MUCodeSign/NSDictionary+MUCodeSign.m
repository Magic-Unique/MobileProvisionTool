//
//  NSDictionary+MUCodeSign.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/27.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "NSDictionary+MUCodeSign.h"

@implementation NSDictionary (MUCodeSign)

+ (instancetype)codesign_dictionaryWithCertificateInfo:(NSDictionary *)certificate {
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:certificate.count];
    [certificate enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
        NSString *type = obj[@"type"];
        id value = obj[@"value"];
        if ([type isEqualToString:@"section"]) {
            NSArray *oris = value;
            NSMutableDictionary *news = [NSMutableDictionary dictionaryWithCapacity:[oris count]];
            [oris enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                news[obj[@"label"]] = obj[@"value"];
            }];
            value = news;
        }
        JSON[obj[@"label"]] = value;
    }];
    if ([certificate isKindOfClass:[NSMutableDictionary class]]) {
        return [JSON mutableCopy];
    } else {
        return [JSON copy];
    }
}

@end
