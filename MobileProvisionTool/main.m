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

#import <Security/Security.h>
#import "MUMobileProvision.h"

#import <objc/runtime.h>

#if DEBUG == 1
#include <sys/sysctl.h>
#endif

void MPTInitCommands() {
    Class class = objc_getMetaClass("CLCommand");
    unsigned count = 0;
    Method *methodList = class_copyMethodList(class, &count);
    for (unsigned i = 0; i < count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        NSString *name = NSStringFromSelector(sel);
        if ([name hasPrefix:@"__init_"]) {
            [CLCommand performSelector:sel];
        }
    }
}

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
        MPTInitCommands();
        if (MPTIsDebuggingInXcode()) {
            [CLCommand handleRequest:[CLRequest requestWithArguments:@[@"devices", @"list", @"-p", @"-i", @"/Users/shuang/Downloads/H0ud1n1 2.mobileprovision"]]];
        } else {
            CLCommandHandleAndReturn();
        }
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
