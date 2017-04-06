//
//  MCFShareUtil.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/27.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFShareUtil.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "MCFNetworkManager+User.h"

@interface MCFShareUtil ()
@property (nonatomic, copy) NSString *url;
@end

@implementation MCFShareUtil

+ (void)showShareMenuToShareInfo:(NSDictionary *)infoDict {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone), @(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbURL = infoDict[@"picPath"];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:infoDict[@"title"] descr:@"欢迎查看我的分享" thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = infoDict[@"loadUrl"];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        [MCFShareUtil didSelectPlatformType:platformType message:messageObject];
    }];
}


+ (void)didSelectPlatformType:(UMSocialPlatformType)platformType message:(UMSocialMessageObject *)messageObject {
    
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


@end
