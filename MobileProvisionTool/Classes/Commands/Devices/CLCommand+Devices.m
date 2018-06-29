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
    CLCommand *devices = [[CLCommand main] defineSubcommand:@"devices"];
    devices.explain = @"设备列表操作";
    {
        CLCommand *list = [devices defineSubcommand:@"list"];
        list.explain = @"列出所有设备";
        list.setQuery(@"input").setAbbr('i').require().setExample(@"/path/to/.mobileprovision").setExplain(@"描述文件路径");
        list.setQuery(@"output").setAbbr('o').optional().setExample(@"/path/to/entitlements").setExplain(@"输出文件路径");
        list.setFlag(@"print").setAbbr('p').setExplain(@"显示所有设备");
        list.setFlag(@"json").setAbbr('j').setExplain(@"使用 JSON 格式输出文件，默认使用 plist 格式");
        [list onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
            NSString *input = [request pathForQuery:@"input"];
            NSString *output = [request pathForQuery:@"output"];
            BOOL print = [request flag:@"print"];
            BOOL json = [request flag:@"json"];
            if (print == NO && output == NO) {
                [command printHelpInfo];
            }
            MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:input];
            if (provision == nil) {
                [request error:@"Can not read the file `%@`.\n", input.lastPathComponent];
                return [CLResponse error:nil];
            }
            
            NSArray<NSString *> *devices = provision.ProvisionedDevices;
            if (print) {
                if (devices == nil) {
                    [request warning:@"The provision is not containing any devices.\n"];
                    return [CLResponse succeed:nil];
                } else {
                    devices = [devices sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        return [obj1 compare:obj2];
                    }];
                    [request print:@"There are %lu devices: \n", devices.count];
                    
                    NSString *lastPrefix = nil;
                    BOOL flag = NO;
                    for (NSString *device in devices) {
                        NSString *currentPrefix = [device substringToIndex:1];
                        
                        if (![currentPrefix isEqualToString:lastPrefix]) {
                            CCPrintf(CCStyleBord, @"\n============================================\n%@\n", currentPrefix.uppercaseString);
                        }
                        
                        lastPrefix = currentPrefix;
                        
                        if (flag) {
                            CCPrintf(0, @"    %@\n", device);
                        } else {
                            CCPrintf(CCStyleForegroundColorDarkGreen, @"    %@\n", device);
                        }
                        flag = !flag;
                    }
                    [request print:@"There are %lu devices.\n\n", devices.count];
                }
            }
            
            if (output) {
                if (json) {
                    NSError *error = nil;
                    NSData *data = [NSJSONSerialization dataWithJSONObject:devices options:kNilOptions error:&error];
                    if (error) {
                        [request error:error.localizedDescription];
                    } else {
                        [data writeToFile:output atomically:YES];
                    }
                } else {
                    [devices writeToFile:output atomically:YES];
                }
            }
            return [CLResponse succeed:nil];
        }];
    }
    {
        CLCommand *contain = [devices defineSubcommand:@"contain"];
        contain.explain = @"检查是否包含某个设备";
        contain.setQuery(@"input").setAbbr('i').require().setExample(@"/path/to/.mobileprovision").setExplain(@"描述文件路径");
        contain.setQuery(@"device").setAbbr('d').require().setExample(@"UDID").setExplain(@"要比较的设备信息，可以是其中的某一段，输入越长越精确");
        [contain onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
            NSString *input = [request pathForQuery:@"input"];
            NSString *UDID = [request stringForQuery:@"device"];
            
            MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:input];
            if (provision == nil) {
                [request error:@"无法读取文件 `%@`.\n", input.lastPathComponent];
                return [CLResponse error:nil];
            }
            
            if (provision.ProvisionsAllDevices) {
                //  Enterprice
                [request success:@"true"];
            } else {
                NSArray<NSString *> *devices = provision.ProvisionedDevices;
                if (UDID.length == 40) {
                    if ([devices containsObject:UDID]) {
                        [request success:@"true"];
                    } else {
                        [request error:@"false"];
                    }
                } else {
                    BOOL contains = NO;
                    NSUInteger count = 0;
                    for (NSString *item in devices) {
                        if ([item containsString:UDID]) {
                            contains = YES;
                            [request info:@"%@ %@", @(++count), item];
                        }
                    }
                }
            }
            
            return [CLResponse succeed:nil];
        }];
    }
}

@end
