//
//  MUFingerprints.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/27.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "MUFingerprints.h"
#import "NSData+MUCodeSign.h"

@implementation MUFingerprints

+ (instancetype)fingerprintsWithDictionary:(NSDictionary *)dictionary {
    NSData *SHA256 = dictionary[@"SHA-256"];
    NSData *SHA1 = dictionary[@"SHA-1"];
    MUFingerprints *fingerprints = [self new];
    fingerprints->_SHA1 = [SHA1 codesign_bytesString];
    fingerprints->_SHA256 = [SHA256 codesign_bytesString];
    return fingerprints;
}

@end
