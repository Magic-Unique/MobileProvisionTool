//
//  MUCertificate.h
//  MobileProvisionTool
//
//  Created by Magic-Unique on 2018/6/10.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUFingerprints : NSObject

@property (nonatomic, strong, readonly) NSString *SHA256;

@property (nonatomic, strong, readonly) NSString *SHA1;

+ (instancetype)fingerprintsWithDictionary:(NSDictionary *)dictionary;

@end

@interface MPValidity : NSObject

@property (nonatomic, strong, readonly) NSDate *notValidAfter;

@property (nonatomic, strong, readonly) NSDate *notValidBefore;

@end


@interface MUCertificate : NSObject

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSString *serialNumber;

@property (nonatomic, assign, readonly) BOOL expired;

@property (nonatomic, strong, readonly) MUFingerprints *fingerprints;

@property (nonatomic, strong, readonly) MPValidity *validity;

@property (nonatomic, strong, readonly) NSData *data;

@property (nonatomic, strong, readonly) NSDictionary *JSON;

+ (instancetype)certificateWithData:(NSData *)data;

@end
