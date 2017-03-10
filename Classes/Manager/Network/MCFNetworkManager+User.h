//
//  MCFNetworkManager+User.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFNetworkManager.h"
#import "MCFUserModel.h"
#import "RegisterModel.h"

@interface MCFNetworkManager (User)

// 注册用户
+ (void)registerUser:(RegisterModel *)user
             success:(void(^)(MCFUserModel *user, NSString *tip))success
             failure:(void(^)(NSError *error))failure;
//用户登录
+ (void)loginWithUser:(RegisterModel *)user
              success:(void(^)(MCFUserModel *user, NSString *tip))success
              failure:(void(^)(NSError *error))failure;
//请求验证码
+ (void)requestVerifyCodeForPhone:(NSString *)phone
                          success:(void(^)(NSString *code, NSString *message))success
                          failure:(void(^)(NSError *error))failure;
//更改密码
+ (void)modifyPassword:(RegisterModel *)newPassWord
               success:(void(^)(NSString *tip))success
               failure:(void(^)(NSError *error))failure;
// 上传文件
+ (void)uploadFile:(NSObject *)file
            success:(void(^)(NSString *tip))success
            failure:(void(^)(NSError *error))failure;
//反馈意见
+ (void)feedBack:(NSString *)content
         contact:(NSString *)contact
         success:(void(^)(NSString *tip))success
         failure:(void(^)(NSError *error))failure;
//上传图片
+ (void)upLoadImage:(UIImage *)image
            success:(void(^)(NSString *tip))success
            failure:(void(^)(NSError *error))failure;
//更新用户信息
+ (void)updateUserProfile:(MCFUserModel *)user
                  success:(void(^)(NSString *tip))success
                  failure:(void(^)(NSError *error))failure;
//绑定手机号码
+ (void)bindPhoneNumber:(NSString *)number
                   code:(NSString *)code
                success:(void(^)(NSString *tip))success
                failure:(void(^)(NSError *error))failure;

@end
