//
//  main.m
//  MobileProvisionTool
//
//  Created by Magic-Unique on 2018/6/8.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLCommand+Entitlements.h"
#import "CLCommand+Devices.h"

#import <CommandLine/CLLanguage.h>

#import <Security/Security.h>
#import "MUMobileProvision.h"

#import <objc/runtime.h>

#if DEBUG == 1
#include <sys/sysctl.h>
#endif

int MPTIsDebuggingInXcode() {
    size_t size = sizeof(struct kinfo_proc);
    struct kinfo_proc info;
    int ret, name[4];
    memset(&info, 0, sizeof(struct kinfo_proc));
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    if ((ret = (sysctl(name, 4, &info, &size, NULL, 0)))) {
        return ret; /* sysctl() failed for some reason */
    }
    return (info.kp_proc.p_flag & P_TRACED) ? 1 : 0;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CLMakeSubcommand(CLCommand, __init_);
        CLCommandMain();
//        NSString *file = @"/Users/shuang/Downloads/H0ud1n1 2.mobileprovision";
//        file = @"/Users/shuang/Desktop/embedded.mobileprovision";
//        MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:file];
//        NSArray *certs = provision.DeveloperCertificates;
//        for (NSData *certData in certs) {
//            SecCertificateRef certRef = SecCertificateCreateWithData(NULL, CFBridgingRetain(certData));
//            CFDictionaryRef values = SecCertificateCopyValues(certRef, NULL, NULL);
//            CFStringRef stringRef;
////            CFStringRef longDesc = SecCertificateCopyLongDescription(NULL, certRef, NULL);
//            SecCertificateCopyCommonName(certRef, &stringRef);
//            NSLog(@"%@", values);
////            longDesc = SecCertificateCopyShortDescription(NULL, certRef, NULL);
////            NSLog(@"%@", longDesc);
//            break;
//        }

    }
    return 0;
}
