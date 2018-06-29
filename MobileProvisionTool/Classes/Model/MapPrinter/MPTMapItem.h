//
//  MPTMapItem.h
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/28.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommandLine/CommandLine.h>

@interface MPTMapItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CCStyle titleStyle;
@property (nonatomic, assign, readonly) NSUInteger titleLength;

@property (nonatomic, strong) id value;
@property (nonatomic, assign) CCStyle valueStyle;

@property (nonatomic, assign, readonly) BOOL isLine;

+ (instancetype)itemWithTitle:(NSString *)title value:(id)value valueStyle:(CCStyle)valueStyle;

+ (instancetype)line;

@end
