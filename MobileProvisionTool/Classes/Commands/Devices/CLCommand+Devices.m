//
//  CLCommand+Devices.m
//  MobileProvisionTool
//
//  Created by Magic-Unique on 2018/6/9.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Devices.h"
#import "MUMobileProvision.h"

@implementation CLCommand (Devices)

+ (void)__init_Devices {
    CLCommand *devices = [[CLCommand mainCommand] defineSubcommand:@"devices"];
    devices.explain = @"设备列表操作";
    {
        CLCommand *list = [devices defineSubcommand:@"list"];
        list.explain = @"列出所有设备";
        list.setQuery(@"input").setAbbr('i').require().setExample(@"/path/to/.mobileprovision").setExplain(@"描述文件路径");
        list.setQuery(@"output").setAbbr('o').optional().setExample(@"/path/to/entitlements").setExplain(@"输出文件路径");
        list.setFlag(@"print").setAbbr('p').setExplain(@"显示所有设备");
        list.setFlag(@"json").setAbbr('j').setExplain(@"使用 JSON 格式输出文件，默认使用 plist 格式");
        [list handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
            NSString *input = [process pathForQuery:@"input"];
            NSString *output = [process pathForQuery:@"output"];
            BOOL print = [process flag:@"print"];
            BOOL json = [process flag:@"json"];
            if (print == NO && output == NO) {
                [command printHelpInfo];
            }
            MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:input];
            if (provision == nil) {
                CLError(@"Can not read the file `%@`.\n", input.lastPathComponent);
                return EXIT_FAILURE;
            }
            
            NSArray<NSString *> *devices = provision.ProvisionedDevices;
            if (print) {
                if (devices == nil) {
                    CLWarning(@"The provision is not containing any devices.\n");
                    return EXIT_SUCCESS;
                } else {
                    devices = [devices sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        return [obj1 compare:obj2];
                    }];
                    CLPrintf(@"There are %lu devices: \n", devices.count);
                    
                    NSString *lastPrefix = nil;
                    BOOL flag = NO;
                    for (NSString *device in devices) {
                        NSString *currentPrefix = [device substringToIndex:1];
                        
                        if (![currentPrefix isEqualToString:lastPrefix]) {
                            CCPrintf(CCStyleBold, @"\n============================================\n%@\n", currentPrefix.uppercaseString);
                        }
                        
                        lastPrefix = currentPrefix;
                        
                        if (flag) {
                            CCPrintf(0, @"    %@\n", device);
                        } else {
                            CCPrintf(CCStyleForegroundColorDarkGreen, @"    %@\n", device);
                        }
                        flag = !flag;
                    }
                    CLPrintf(@"There are %lu devices.\n\n", devices.count);
                }
            }
            
            if (output) {
                if (json) {
                    NSError *error = nil;
                    NSData *data = [NSJSONSerialization dataWithJSONObject:devices options:kNilOptions error:&error];
                    if (error) {
                        CLError(error.localizedDescription);
                    } else {
                        [data writeToFile:output atomically:YES];
                    }
                } else {
                    [devices writeToFile:output atomically:YES];
                }
            }
            return EXIT_SUCCESS;
        }];
    }
    {
        CLCommand *contain = [devices defineSubcommand:@"contain"];
        contain.explain = @"检查是否包含某个设备";
        contain.setQuery(@"input").setAbbr('i').require().setExample(@"/path/to/.mobileprovision").setExplain(@"描述文件路径");
        contain.setQuery(@"device").setAbbr('d').require().setExample(@"UDID").setExplain(@"要比较的设备信息，可以是其中的某一段，输入越长越精确");
        [contain handleProcess:^int(CLCommand * _Nonnull command, CLProcess * _Nonnull process) {
            NSString *input = [process pathForQuery:@"input"];
            NSString *UDID = [process stringForQuery:@"device"];
            
            MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:input];
            if (provision == nil) {
                CLError(@"无法读取文件 `%@`.\n", input.lastPathComponent);
                return EXIT_FAILURE;
            }
            
            if (provision.ProvisionsAllDevices) {
                //  Enterprice
                CLSuccess(@"true");
            } else {
                NSArray<NSString *> *devices = provision.ProvisionedDevices;
                if (UDID.length == 40) {
                    if ([devices containsObject:UDID]) {
                        CLSuccess(@"true");
                    } else {
                        CLError(@"false");
                    }
                } else {
                    BOOL contains = NO;
                    NSUInteger count = 0;
                    for (NSString *item in devices) {
                        if ([item containsString:UDID]) {
                            contains = YES;
                            CLInfo(@"%@ %@", @(++count), item);
                        }
                    }
                }
            }
            
            return EXIT_SUCCESS;
        }];
    }
}

@end
