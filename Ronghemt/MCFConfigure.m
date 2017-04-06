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
        
        cfg.umengAppKey = umengAppKey;
        if (appType == AppEditionStandard) {
            
            cfg.APPNetHost        = AppStandardHost;
            cfg.APPNaviType       = NaviTypeStandard;
            cfg.APPIdWX           = AppIdWX;
            cfg.AppSecretWX       = AppSecretWX;
            cfg.UMChannel         = UMENG_CHANNEL;
            cfg.AppCollect        = APPUserCollect;
            cfg.registProtocol    = registProtocol;
            cfg.shareUrl          = ShareUrlSTD;
            cfg.siteCode          = IdentityCode;
            
        } else if (appType == AppEditionWF) {
            cfg.APPNetHost        = AppWFHost;
            cfg.APPNaviType       = NaviTypeWF;
            cfg.APPIdWX           = AppIdWXWF;
            cfg.AppSecretWX       = AppSecretWXWF;
            cfg.UMChannel         = UMENG_CHANNEL_WF;
            cfg.AppCollect        = APPUserCollect;
            cfg.registProtocol    = registProtocolwf;
            cfg.shareUrl          = ShareUrlWF;
            cfg.siteCode          = IdentityCodeWF;
        }
    });
    return cfg;
}

- (void)setSiteCode:(NSString *)siteCode {
    _siteCode = siteCode;
}

- (void)setShareUrl:(NSString *)shareUrl {
    _shareUrl = shareUrl;
}

- (void)setRegistProtocol:(NSString *)registProtocol {
    _registProtocol = registProtocol;
}

- (void)setAPPNetHost:(NSString *)APPNetHost {
    _APPNetHost = APPNetHost;
}

- (void)setAPPNaviType:(NSString *)APPNaviType {
    _APPNaviType = APPNaviType;
}

- (void)setAPPIdWX:(NSString *)APPIdWX {
    _APPIdWX = APPIdWX;
}

- (void)setAppSecretWX:(NSString *)AppSecretWX {
    _AppSecretWX = AppSecretWX;
}

- (void)setUmengAppKey:(NSString *)umengAppKey {
    _umengAppKey = umengAppKey;
}

- (void)setUMChannel:(NSString *)UMChannel {
    _UMChannel = UMChannel;
}

- (void)setAppCollect:(NSString *)AppCollect {
    _AppCollect = AppCollect;
}
@end
