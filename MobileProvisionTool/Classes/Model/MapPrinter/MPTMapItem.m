//
//  MPTMapItem.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/28.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "MPTMapItem.h"
#import "NSString+Space.h"
#import "MPTMutableMap.h"

@implementation MPTMapItem

+ (instancetype)itemWithTitle:(NSString *)title value:(id)value valueStyle:(CCStyle)valueStyle {
    MPTMapItem *item = [[self alloc] init];
    item.title = title;
    item.value = value;
    item.valueStyle = valueStyle;
    return item;
}

- (NSUInteger)titleLength {
    return self.title.printLength;
}

+ (instancetype)line {
    MPTMapItem *item = [self new];
    item->_isLine = YES;
    return item;
}

@end
