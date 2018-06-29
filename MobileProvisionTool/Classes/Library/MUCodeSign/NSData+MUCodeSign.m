//
//  NSData+MUCodeSign.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/27.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "NSData+MUCodeSign.h"

@implementation NSData (MUCodeSign)

- (NSString *)codesign_bytesString {
    NSString *string = self.description;
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

@end
