//
//  CLCommand+Entitlements.m
//  MobileProvisionTool
//
//  Created by Magic-Unique on 2018/6/8.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Entitlements.h"
#import <CommandLine/CLCommand+Print.h>
#import "MUMobileProvision.h"

@implementation CLCommand (Entitlements)

+ (void)__init_Entitlements {
    CLCommand *entitlements = [[CLCommand main] defineSubcommand:@"entitlements"];
    entitlements.explain = @"输出描述文件中的权限";
    entitlements.setQuery(@"input").setAbbr('i').require().setExample(@"/path/to/.mobileprovision").setExplain(@"输入路径");
    entitlements.setQuery(@"output").setAbbr('o').optional().setExample(@"/path/to/entitlements").setExplain(@"plist 输出路径");
    entitlements.setFlag(@"print").setAbbr('p').setExplain(@"显示到窗口中");
    [entitlements onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
        NSString *input = [request pathForQuery:@"input"];
        NSString *output = [request pathForQuery:@"output"];
        BOOL print = [request.flags containsObject:@"print"];
        if (print == NO && output == NO) {
            [command printHelpInfo];
        }
        MUMobileProvision *provision = [MUMobileProvision mobileProvisionWithContentsOfFile:input];
        MUEntitlements *entitlements = provision.Entitlements;
        if (print) {
            NSData *data = [NSPropertyListSerialization dataWithPropertyList:entitlements.JSON
                                                                      format:NSPropertyListXMLFormat_v1_0
                                                                     options:0
                                                                       error:nil];
            NSString *log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            printf("%s\n", log.UTF8String);
        }
        if (output) {
            [entitlements.JSON writeToFile:output atomically:YES];
        }
        return [CLResponse succeed:nil];
    }];
}

@end
