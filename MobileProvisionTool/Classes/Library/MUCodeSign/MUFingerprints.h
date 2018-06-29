//
//  MUFingerprints.h
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/27.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUFingerprints : NSObject

@property (nonatomic, strong, readonly) NSString *SHA256;

@property (nonatomic, strong, readonly) NSString *SHA1;

+ (instancetype)fingerprintsWithDictionary:(NSDictionary *)dictionary;

@end
