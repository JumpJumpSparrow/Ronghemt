//
//  MCFConfigure.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFConfigure.h"

@implementation MCFConfigure

+ (instancetype)cfg {
    static MCFConfigure *cfg;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cfg = [[MCFConfigure alloc] init];
    });
    return cfg;
}

- (NSString *)APPHost {
    static NSString *host = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (appType == AppEditionStandard) host = AppStandardHost;
        else host = AppWFHost;
    });
    return host;
}

- (NSString *)NaviType {
    static NSString *NaviHost = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (appType == AppEditionStandard) NaviHost = NaviTypeStandard;
        else NaviHost = NaviTypeWF;
    });
    return NaviHost;
}

@end
