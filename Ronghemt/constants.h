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
    AppEditionWF          = 1
};

static const AppEdition appType = AppEditionStandard;// 更改应用版本

static NSString *AppStandardHost      = @"http://user.dev.ctvcloud.com/api/";//标准版
static NSString *AppWFHost            = @"http://user.dev.ctvcloud.com/api/";//后续将有改变f

static NSString *NaviTypeStandard     = @"http://app.dev.wfrbw.com/html/nav.html";
static NSString *NaviTypeWF           = @"http://app2.dev.ctvcloud.com/html/nav.html";

static NSString *AppColorSelected    =@"#ef7032";
static NSString *AppColorNormal      =@"#929292";


@interface constants : NSObject

@end
