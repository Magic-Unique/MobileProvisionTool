//
//  MPTMutableMap.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/28.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "MPTMutableMap.h"
#import "NSString+Space.h"

@implementation MPTMutableMap

- (instancetype)init {
    self = [super init];
    if (self) {
        _titleStyle = CCStyleBold;
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)printWithSpace:(NSUInteger)space {
    NSStringEncoding encoding = self.en ? NSUTF8StringEncoding : NSUnicodeStringEncoding;
    
    NSUInteger maxLength = 0;
    for (MPTMapItem *item in self.items) {
        NSUInteger length = [item.title lengthOfBytesUsingEncoding:encoding];
        if (maxLength < length) {
            maxLength = length;
        }
    }
    maxLength += space > 0 ? space : 4;
    
    for (MPTMapItem *item in self.items) {
        NSUInteger length = [item.title lengthOfBytesUsingEncoding:encoding];
        
        CCPrintf(0, @"%@", [@" " stringWithRepeat:maxLength - length]);
        if (item.isLine) {
            CCPrintf(0, @"\n");
            continue;
        }
        CCPrintf(self.titleStyle, @"%@: ", item.title);
        if ([item.value isKindOfClass:[MPTMutableMap class]]) {
            CCPrintf(0, @"\n");
            MPTMutableMap *map = item.value;
            map.titleStyle = 0;
            [map printWithSpace:maxLength + 2];
        } else if ([item.value isKindOfClass:[NSArray class]]) {
            NSArray *value = item.value;
            CCPrintf(item.valueStyle, [NSString stringWithFormat:@"%@", [value componentsJoinedByString:@", "]]);
            CCPrintf(0, @"\n");
        } else {
            CCPrintf(item.valueStyle, @"%@", [NSString stringWithObject:item.value en:self.en]);
            CCPrintf(0, @"\n");
        }
    }
}

@end
