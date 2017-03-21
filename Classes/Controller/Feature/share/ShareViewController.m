//
//  ShareViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ShareViewController.h"
#import "ThirdLogInView.h"
#import <UMSocialCore/UMSocialCore.h>

@interface ShareViewController ()<ThirdLogInDelegate>
@property (nonatomic, strong) ThirdLogInView *thirdLogInView;
@property (nonatomic, copy) NSString *shareUrl;
@end

@implementation ShareViewController

- (ThirdLogInView *)thirdLogInView {
    if (_thirdLogInView == nil) {
        _thirdLogInView = [[ThirdLogInView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 160.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 160.0f)];
        _thirdLogInView.delegate = self;
        _thirdLogInView.backgroundColor = [UIColor whiteColor];
        _thirdLogInView.titleLabel.hidden = YES;
    }
    return _thirdLogInView;
}

- (instancetype)initWithUrl:(NSString *)shareUrl {
    self = [super init];
    self.shareUrl = shareUrl;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.thirdLogInView];
}

- (void)didSelectLoginMethod:(NSInteger)index {
    UMSocialPlatformType platformType;
    
    switch (index) {
        case 1: // QQ
            platformType = UMSocialPlatformType_QQ;
            break;
            
        case 2: // weibo
            platformType = UMSocialPlatformType_Sina;
            break;
        case 3: // weixin
            platformType = UMSocialPlatformType_WechatTimeLine;
            break;
        default:
            break;
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享测试" descr:@"欢迎查看我的分享" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
