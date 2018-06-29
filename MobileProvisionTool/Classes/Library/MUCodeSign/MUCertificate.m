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
        JSON = [NSDictionary codesign_dictionaryWithCertificateInfo:JSON];
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
        _expireDate = JSON[@"Expired"];
    } else {
        _expired = NO;
        _expireDate = JSON[@"Expires"];
    }
    _createDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[JSON[@"Not Valid Before"] doubleValue]];
    _fingerprints = [MUFingerprints fingerprintsWithDictionary:JSON[@"Fingerprints"]];
}

+ (instancetype)certificateWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

@end
