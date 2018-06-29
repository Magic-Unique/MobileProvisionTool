//
//  CLCommand+Main.m
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/28.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "CLCommand+Main.h"

@implementation CLCommand (Main)

+ (void)__init_Main {
    CLCommand *main = CLCommand.main;
    main.explain = @"描述文件工具，GitHub: https://github.com/Magic-Unique/MobileProvisionTool";
    [CLCommand setVersion:@"1.0.0"];
}

@end
