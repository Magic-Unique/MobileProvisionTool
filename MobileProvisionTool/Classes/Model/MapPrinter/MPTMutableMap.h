//
//  MPTMutableMap.h
//  MobileProvisionTool
//
//  Created by 吴双 on 2018/6/28.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPTMapItem.h"

@interface MPTMutableMap : NSObject

@property (nonatomic, assign) BOOL en;

@property (nonatomic, assign) CCStyle titleStyle;

@property (nonatomic, strong, readonly) NSMutableArray<MPTMapItem *> *items;

- (void)printWithSpace:(NSUInteger)space;

@end
