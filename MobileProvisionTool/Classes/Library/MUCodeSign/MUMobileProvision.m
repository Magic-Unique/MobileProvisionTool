//
//  MUMobileProvision.m
//  RingTone
//
//  Created by Shuang Wu on 2017/1/19.
//  Copyright © 2017年 Mia Tse. All rights reserved.
//

#import "MUMobileProvision.h"
#import "MUCertificate.h"

static NSDictionary * mobileProvisionObjectWithContentsOfFile(NSString *file) {
	NSDictionary *dic = nil;
	
	NSString *embeddedPath = file;
	NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.plist"];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:embeddedPath]) {
		
		NSString *embeddedProvisioning = [NSString stringWithContentsOfFile:embeddedPath encoding:NSASCIIStringEncoding error:nil];
		
		NSRange headRange = [embeddedProvisioning rangeOfString:@"<plist"];
		NSRange footRange = [embeddedProvisioning rangeOfString:@"plist>"];
		NSRange enableRange = NSMakeRange(headRange.location, footRange.location + footRange.length - headRange.location);
		
		NSString *objStr = [embeddedProvisioning substringWithRange:enableRange];
		
		
		[objStr writeToFile:tempPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
		dic = [NSDictionary dictionaryWithContentsOfFile:tempPath];
		[[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
	}
	return dic;
}

@implementation MUMobileProvision

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
#define SetVar(k) _##k = dictionary[@#k]
		SetVar(AppIDName);
		SetVar(ApplicationIdentifierPrefix);
		SetVar(CreationDate);
		SetVar(DeveloperCertificates);
		SetVar(ExpirationDate);
		SetVar(Name);
		SetVar(Platform);
		SetVar(ProvisionedDevices);
		SetVar(TeamIdentifier);
		SetVar(TeamName);
		SetVar(UUID);
#undef SetVar
        _ProvisionsAllDevices = [dictionary[@"ProvisionsAllDevices"] boolValue];
        _DeveloperCertificates = ({
            NSArray<NSData *> *datas = dictionary[@"DeveloperCertificates"];
            NSMutableArray *certs = nil;
            if (datas) {
                certs = [NSMutableArray arrayWithCapacity:datas.count];
                [datas enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MUCertificate *cert = [MUCertificate certificateWithData:obj];
                    [certs addObject:cert];
                }];
            }
            [certs copy];
        });
		_Entitlements = [MUEntitlements entitlementsWithDictionary:dictionary[@"Entitlements"]];
		_TimeToLive = [dictionary[@"TimeToLive"] unsignedIntegerValue];
		_Version = [dictionary[@"Version"] unsignedIntegerValue];
        _JSON = dictionary;
	}
	return self;
}

+ (instancetype)localMobileProvision {
	return [self mobileProvisionWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"embedded" ofType:@"mobileprovision"]];
}

+ (instancetype)mobileProvisionWithContentsOfFile:(NSString *)file {
	NSDictionary *obj = mobileProvisionObjectWithContentsOfFile(file);
	if (!obj) {
		return nil;
	}
	return [[self alloc] initWithDictionary:obj];
}

@end
