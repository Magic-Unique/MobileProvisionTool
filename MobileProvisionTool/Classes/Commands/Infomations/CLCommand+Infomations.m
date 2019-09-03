//
//  CLCommand+Infomations.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/28.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Infomations.h"
#import "MUMobileProvision.h"
#import "NSString+Space.h"

#import "MPTMutableMap.h"

@implementation CLCommand (Infomations)

+ (void)__init_Print {
    CLCommand *print = [CLCommand.mainCommand defineSubcommand:@"print"];
    print.explain = @"输出文件信息";
    print.setFlag(@"en").setExplain(@"Print with English");
    print.addRequirePath(@"input");
    [print handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        NSString *input = [CLIOPath abslutePath:process.paths.firstObject];
        MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:input];
        if (provision == nil) {
            CLError(@"Can not read the file");
        } else {
            MPTMutableMap *map = [[MPTMutableMap alloc] init];
            if ([process flag:@"en"]) {
                map.en = YES;
                [map.items addObject:[MPTMapItem itemWithTitle:@"Name" value:provision.Name valueStyle:0]];
                [map.items addObject:[MPTMapItem itemWithTitle:@"App ID Name" value:provision.AppIDName valueStyle:0]];
                [map.items addObject:[MPTMapItem itemWithTitle:@"Create Date" value:provision.CreationDate valueStyle:0]];
                [map.items addObject:[MPTMapItem itemWithTitle:@"Expire Date" value:provision.ExpirationDate valueStyle:0]];
                [map.items addObject:[MPTMapItem itemWithTitle:@"Platform" value:provision.Platform valueStyle:0]];
                
                MPTMutableMap *certificates = [[MPTMutableMap alloc] init];
                certificates.en = YES;
                [provision.DeveloperCertificates enumerateObjectsUsingBlock:^(MUCertificate *obj, NSUInteger idx, BOOL *stop) {
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"Name" value:obj.name valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"Not Valid Before" value:obj.validity.notValidBefore valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"Not Valid After" value:obj.validity.notValidAfter valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"SHA-1" value:obj.fingerprints.SHA1.uppercaseString valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"SHA-256" value:obj.fingerprints.SHA256.uppercaseString valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem line]];
                }];
                [map.items addObject:[MPTMapItem itemWithTitle:@"Certificates" value:certificates valueStyle:0]];
                
                [map.items addObject:[MPTMapItem itemWithTitle:@"Devices" value:@(provision.ProvisionedDevices.count) valueStyle:0]];
                
                MPTMutableMap *entitlements = [[MPTMutableMap alloc] init];
                entitlements.en = YES;
                [provision.Entitlements.JSON enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [entitlements.items addObject:[MPTMapItem itemWithTitle:key value:obj valueStyle:CCStyleLight]];
                }];
                [map.items addObject:[MPTMapItem itemWithTitle:@"Entitlements" value:entitlements valueStyle:0]];
            } else {
                [map.items addObject:[MPTMapItem itemWithTitle:@"描述文件名称" value:provision.Name valueStyle:0]];
                [map.items addObject:[MPTMapItem itemWithTitle:@"应用程序名称" value:provision.AppIDName valueStyle:0]];
                [map.items addObject:[MPTMapItem itemWithTitle:@"创建日期" value:provision.CreationDate valueStyle:0]];
                [map.items addObject:[MPTMapItem itemWithTitle:@"过期日期" value:provision.ExpirationDate valueStyle:0]];
                [map.items addObject:[MPTMapItem itemWithTitle:@"开发平台" value:provision.Platform valueStyle:0]];
                
                MPTMutableMap *certificates = [[MPTMutableMap alloc] init];
                [provision.DeveloperCertificates enumerateObjectsUsingBlock:^(MUCertificate *obj, NSUInteger idx, BOOL *stop) {
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"证书名称" value:obj.name valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"创建时间" value:obj.validity.notValidBefore valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"过期时间" value:obj.validity.notValidAfter valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"一代哈希" value:obj.fingerprints.SHA1.uppercaseString valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem itemWithTitle:@"二代哈希" value:obj.fingerprints.SHA256.uppercaseString valueStyle:CCStyleLight]];
                    [certificates.items addObject:[MPTMapItem line]];
                }];
                [map.items addObject:[MPTMapItem itemWithTitle:@"开发者证书列表" value:certificates valueStyle:0]];
                
                [map.items addObject:[MPTMapItem itemWithTitle:@"设备个数" value:@(provision.ProvisionedDevices.count) valueStyle:0]];
                
                MPTMutableMap *entitlements = [[MPTMutableMap alloc] init];
                entitlements.en = YES;
                [provision.Entitlements.JSON enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [entitlements.items addObject:[MPTMapItem itemWithTitle:key value:obj valueStyle:CCStyleLight]];
                }];
                [map.items addObject:[MPTMapItem itemWithTitle:@"进程权限" value:entitlements valueStyle:0]];
                
            }
            
            [map printWithSpace:0];
        }
        return EXIT_SUCCESS;
    }];
}

@end
