//
//  NSDictionary+MUCodeSign.h
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/27.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MUCodeSign)

+ (instancetype)codesign_dictionaryWithCertificateInfo:(NSDictionary *)certificate;

@end
