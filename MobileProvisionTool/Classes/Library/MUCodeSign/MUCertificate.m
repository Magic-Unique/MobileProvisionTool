//
//  MUCertificate.m
//  MobileProvisionTool
//
//  Created by Magic-Unique on 2018/6/10.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "MUCertificate.h"
#import <Security/Security.h>
#import "NSDictionary+MUCodeSign.h"
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

@implementation MPValidity

+ (instancetype)validityWithDictionary:(NSDictionary *)dictionary {
    MPValidity *validity = [[self alloc] init];
    validity->_notValidAfter = [NSDate dateWithTimeIntervalSinceReferenceDate:[dictionary[@"Not Valid After"] doubleValue]];
    validity->_notValidBefore = [NSDate dateWithTimeIntervalSinceReferenceDate:[dictionary[@"Not Valid Before"] doubleValue]];
    return validity;
}

@end


@interface MUCertificate ()
{
    SecCertificateRef _certificate;
}

@end

@implementation MUCertificate

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = data;
        _certificate = SecCertificateCreateWithData(NULL, CFBridgingRetain(_data));
        _name = CFBridgingRelease(SecCertificateCopySubjectSummary(_certificate));
        
        NSDictionary *JSON = (__bridge NSDictionary *)SecCertificateCopyValues(_certificate, NULL, NULL);
//        NSLog(@"%@", JSON);
        JSON = [NSDictionary codesign_dictionaryWithCertificateInfo:JSON];
//        NSLog(@"%@", JSON);
        
        _JSON = JSON;
        
        [self format];
    }
    return self;
}

- (void)dealloc {
    CFRelease(_certificate);
}

- (void)format {
    NSDictionary *JSON = _JSON;
    
    _serialNumber = JSON[@"Serial Number"];
    
    if (JSON[@"Expired"]) {
        _expired = YES;
    } else {
        _expired = NO;
    }
    _validity = [MPValidity validityWithDictionary:JSON];
    _fingerprints = [MUFingerprints fingerprintsWithDictionary:JSON[@"Fingerprints"]];
}

+ (instancetype)certificateWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

@end
