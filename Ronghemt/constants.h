//
//  constants.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AppEdition) {
    AppEditionStandard    = 0,
    AppEditionWF          = 1,
    AppEditionLZ          = 2
};

static const AppEdition appType = AppEditionWF;// 更改应用版本 注意事项：1>URL scheme 2>bundleID 3>配置文件 4>分享地址


static NSString *AppColorSelected         =@"#ef7032";
static NSString *AppColorNormal           =@"#929292";
#define APPGRAY     [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1]

static NSString *AppUserKey               = @"AppUserKeyAppUserKey";

//standard==================================
//static NSString *AppStandardHost          = @"http://user.dev.ctvcloud.com/api/";
//static NSString *NaviTypeStandard         = @"http://app2.dev.ctvcloud.com/html/nav.html";
static NSString *AppStandardHost          = @"http://api.ctv-cloud.com/api/";
static NSString *NaviTypeStandard         = @"http://app-intra.ctv-cloud.com/api/append_nodes.php";
static NSString *umengAppKey              = @"58b3a5598f4a9d0ba100114a";
static NSString *UMENG_CHANNEL            = @"RongHeMeiTi";
static NSString *AppIdWX                  = @"wx8b0671c98908cef7";
static NSString *AppSecretWX              = @"50e4894fca6ee406679198a580c325bf";
static NSString *APPUserCollect           = @"http://app2.dev.ctvcloud.com/html/shoucang.html";
static NSString *registProtocol           = @"http://api.cdn.ctv-cloud.com/appinfomation.php?id=";
static NSString *ShareUrlSTD              = @"http://app-intra.ctv-cloud.com/json/comment.json";
static NSString *IdentityCode             = @"s33";

//Wifang====================================
static NSString *NaviTypeWF               = @"http://app.dev.wfrbw.com/html/nav.html";
static NSString *AppWFHost                = @"http://user.dev.ctvcloud.com/api/";//后续将有改变f
static NSString *UMENG_CHANNEL_WF         = @"WeiFangRiBao";
static NSString *AppIdWXWF                = @"wx709965163d15c292";
static NSString *AppSecretWXWF            = @"26195ef0259d9e9ff2df47a23977b495";
static NSString *registProtocolwf         = @"http://api.cdn.ctv-cloud.com/appinfomation.php?id=";
static NSString *ShareUrlWF               = @"http://stdapp-wfrb.dev.ctvcloud.com/json/comment.json";
static NSString *IdentityCodeWF           = @"s26";

// LaiZhou

static NSString *ShareUrlLZ               = @"http://app-intra.laizhou.ctv-cloud.com/json/comment.json";
static NSString *IdentityCodeLZ           = @"s101";

@interface constants : NSObject
@end
