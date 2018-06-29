//
//  MUMobileProvision.h
//  RingTone
//
//  Created by Shuang Wu on 2017/1/19.
//  Copyright © 2017年 Mia Tse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUCertificate.h"
#import "MUEntitlements.h"

@interface MUMobileProvision : NSObject

@property (nonatomic, strong, readonly) NSString *AppIDName;

@property (nonatomic, strong, readonly) NSArray<NSString *> *ApplicationIdentifierPrefix;

@property (nonatomic, strong, readonly) NSDate *CreationDate;

@property (nonatomic, strong, readonly) NSArray<MUCertificate *> *DeveloperCertificates;

@property (nonatomic, strong, readonly) MUEntitlements *Entitlements;

@property (nonatomic, strong, readonly) NSDate *ExpirationDate;

@property (nonatomic, strong, readonly) NSString *Name;

@property (nonatomic, strong, readonly) NSArray<NSString *> *Platform;

/** Enable in Enterprice */
@property (nonatomic, assign, readonly) BOOL ProvisionsAllDevices;

/** Enable in Development */
@property (nonatomic, strong, readonly) NSArray<NSString *> *ProvisionedDevices;

@property (nonatomic, strong, readonly) NSArray<NSString *> *TeamIdentifier;

@property (nonatomic, strong, readonly) NSString *TeamName;

@property (nonatomic, assign, readonly) NSUInteger TimeToLive;

@property (nonatomic, strong, readonly) NSString *UUID;

@property (nonatomic, assign, readonly) NSUInteger Version;

@property (nonatomic, strong, readonly) NSDictionary *JSON;

+ (instancetype)localMobileProvision;

+ (instancetype)mobileProvisionWithContentsOfFile:(NSString *)file;

@end
