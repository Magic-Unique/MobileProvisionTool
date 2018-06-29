//
//  NSString+Space.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/28.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "NSString+Space.h"

@implementation NSString (Space)

- (instancetype)stringWithRepeat:(NSUInteger)repeat {
    return [[self class] stringWithString:self repeat:repeat];
}

+ (instancetype)stringWithString:(NSString *)string repeat:(NSUInteger)repeat {
    NSMutableString *output = [NSMutableString string];
    for (NSUInteger i = 0; i < repeat; i++) {
        [output appendString:string];
    }
    if ([self isKindOfClass:[NSString class]]) {
        return [output copy];
    } else {
        return output;
    }
}

- (NSUInteger)printLength  {
    return [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
}

+ (instancetype)stringWithObject:(id)object en:(BOOL)en {
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSDate class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = en ? @"yyyy-MM-dd hh:mm:ss" : @"yyyy年MM月dd日 hh:mm:ss";
        return [formatter stringFromDate:object];
    } else {
        return [NSString stringWithFormat:@"%@", object];
    }
}

@end
