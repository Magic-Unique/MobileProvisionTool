//
//  CLCommand+List.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2019/8/28.
//  Copyright © 2019 unique. All rights reserved.
//

#import "CLCommand+List.h"
#import "MUMobileProvision.h"

static NSString *MPTProvisioningProfilesPath(void) {
    return [NSString stringWithFormat:@"%@/Library/MobileDevice/Provisioning Profiles", NSHomeDirectory()];
}

@implementation CLCommand (List)

+ (void)__init_list {
    CLCommand *local = [[CLCommand mainCommand] defineSubcommand:@"local"];
    local.explain = @"本地描述文件菜单";
    
    CLCommand *list = [local defineForwardingSubcommand:@"list"];
    list.explain = @"列出所有描述文件名称";
    list.setQuery(@"search").setAbbr('s').optional().setExplain(@"搜索并过滤名称");
    [list handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        NSString *path = MPTProvisioningProfilesPath();
        NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        NSMutableDictionary *provisions = [NSMutableDictionary dictionary];
        
        for (NSString *item in list) {
            NSString *_path = [path stringByAppendingPathComponent:item];
            MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:_path];
            if ([provision.ExpirationDate timeIntervalSinceNow] > 0) {
                MUMobileProvision *old = provisions[provision.Name];
                if (old) {
                    if (old.CreationDate.timeIntervalSince1970 < provision.CreationDate.timeIntervalSince1970) {
                        provisions[provision.Name] = provision;
                    }
                } else {
                    provisions[provision.Name] = provision;
                }
            }
        }
        
        NSString *search = [process stringForQuery:@"search"];
        NSArray *searches = [search componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSArray *names = [provisions.allKeys sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *name in names) {
            MUMobileProvision *provision = provisions[name];
            if (search) {
                BOOL right = YES;
                for (NSString *search in searches) {
                    if (![provision.Name containsString:search]) {
                        right = NO;
                        break;
                    }
                }
                if (!right) {
                    continue;
                }
            }
            CLInfo(@"* %@", provision.Name);
        }
        return EXIT_SUCCESS;
    }];
    
    CLCommand *clean = [local defineSubcommand:@"clean"];
    clean.setFlag(@"expired").setAbbr('e').setExplain(@"删除所有过期的描述文件");
    clean.setFlag(@"old").setAbbr('o').setExplain(@"删除旧的描述文件（同名且创建日期较前）");
    clean.setQuery(@"name").setAbbr('n').optional().setExplain(@"删除指定名称的描述文件");
    clean.explain = @"清除使用不到的描述文件";
    [clean handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        BOOL cleanExpired = [process flag:@"expired"];
        BOOL cleanOld = [process flag:@"old"];
        NSString *name = process.queries[@"name"];
        
        if (!cleanExpired && !cleanOld && !name) {
            CLError(@"You must input one or more of `--expired|-e` or `--old|-o` or `--name|-n xxx` to special clean rule");
            return EXIT_FAILURE;
        }
        
        
        NSString *path = MPTProvisioningProfilesPath();
        NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        NSMutableDictionary *provisions = [NSMutableDictionary dictionary];
        
        for (NSString *item in list) {
            NSString *_path = [path stringByAppendingPathComponent:item];
            MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:_path];
            if (name && [provision.Name isEqualToString:name]) {
                CLInfo(@"Delete %@", provision.UUID);
                [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
                continue;
            }
            if ([provision.ExpirationDate timeIntervalSinceNow] > 0) {
                MUMobileProvision *old = provisions[provision.Name];
                if (old) {
                    if (old.CreationDate.timeIntervalSince1970 < provision.CreationDate.timeIntervalSince1970) {
                        provisions[provision.Name] = provision;
                        if (cleanOld) {
                            CLInfo(@"Delete %@", provision.UUID);
                            [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
                        }
                    }
                } else {
                    provisions[provision.Name] = provision;
                }
            } else {
                if (cleanExpired) {
                    CLInfo(@"Delete %@", provision.UUID);
                    [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
                }
            }
        }
        
        
        return EXIT_SUCCESS;
    }];
    
    
    CLCommand *sign = [local defineSubcommand:@"sign"];
    sign.setQuery(@"input").setAbbr('i').require().setExplain(@"要签名的 ipa 路径");
    sign.setQuery(@"search").setAbbr('s').optional().setExplain(@"搜索并过滤名称");
    sign.explain = @"使用描述文件签名 IPA";
    [sign handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
        NSString *input = [process pathForQuery:@"input"];
        NSString *output = [input.stringByDeletingPathExtension stringByAppendingString:@"_sign.ipa"];
        NSString *search = [process stringForQuery:@"search"];
        
        
        NSString *path = MPTProvisioningProfilesPath();
        NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        NSMutableDictionary *provisions = [NSMutableDictionary dictionary];
        
        for (NSString *item in list) {
            NSString *_path = [path stringByAppendingPathComponent:item];
            MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:_path];
            if ([provision.ExpirationDate timeIntervalSinceNow] > 0) {
                MUMobileProvision *old = provisions[provision.Name];
                if (old) {
                    if (old.CreationDate.timeIntervalSince1970 < provision.CreationDate.timeIntervalSince1970) {
                        provisions[provision.Name] = provision;
                    }
                } else {
                    provisions[provision.Name] = provision;
                }
            }
        }
        
        NSArray *searches = [search componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSArray *names = [provisions.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        NSMutableArray *result = [NSMutableArray array];
        
        for (NSString *name in names) {
            MUMobileProvision *provision = provisions[name];
            if (search) {
                BOOL right = YES;
                for (NSString *search in searches) {
                    if (![provision.Name containsString:search]) {
                        right = NO;
                        break;
                    }
                }
                if (!right) {
                    continue;
                }
            }
            [result addObject:provision];
        }
        
        MUMobileProvision *provision = nil;
        if (result.count == 1) {
            provision = result.firstObject;
        } else {
            for (NSUInteger i = 0; i < result.count; i++) {
                MUMobileProvision *provision = result[i];
                CLInfo(@"%2d %@", (int)i, provision.Name);
            }
            CLPrintf(@"Choose Name: ");
            int choose = 0;
            scanf("%d", &choose);
            provision = result[choose];
        }
        
        NSString *_path = [MPTProvisioningProfilesPath() stringByAppendingFormat:@"/%@.mobileprovision", provision.UUID];
        CLSystem(@"ktool resign -c '%@' -m '%@' '%@' '%@'", provision.DeveloperCertificates.firstObject.name, _path, input, output);
        
        return EXIT_SUCCESS;
    }];
}

@end
