//
//  MUCertificate.h
//  MobileProvisionTool
//
//  Created by Magic-Unique on 2018/6/10.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUFingerprints.h"

@interface MUCertificate : NSObject

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSString *serialNumber;

@property (nonatomic, strong, readonly) NSDate *expireDate;

@property (nonatomic, strong, readonly) NSDate *createDate;

@property (nonatomic, assign, readonly) BOOL expired;

@property (nonatomic, strong, readonly) MUFingerprints *fingerprints;



@property (nonatomic, strong, readonly) NSData *data;

@property (nonatomic, strong, readonly) NSDictionary *JSON;

+ (instancetype)certificateWithData:(NSData *)data;

@end
