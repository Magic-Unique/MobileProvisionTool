//
//  NSString+Space.h
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/28.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Space)

+ (instancetype)stringWithString:(NSString *)string repeat:(NSUInteger)repeat;

- (instancetype)stringWithRepeat:(NSUInteger)repeat;

- (NSUInteger)printLength;

+ (instancetype)stringWithObject:(id)object en:(BOOL)en;

@end
