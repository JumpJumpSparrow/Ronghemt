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
#import "BreakNews.h"
#import "CommentModel.h"

@interface MCFNetworkManager (User)

// 注册用户
+ (void)registerUser:(RegisterModel *)user
             success:(void(^)(MCFUserModel *user, NSString *tip))success
             failure:(void(^)(NSError *error))failure;
//用户登录
+ (void)loginWithUser:(RegisterModel *)user
              success:(void(^)(MCFUserModel *user, NSString *tip))success
              failure:(void(^)(NSError *error))failure;
// 验证登录是否有效
+ (void)verifySession:(void(^)())valid
              invalid:(void(^)())invalid
              failure:(void(^)(NSError *error))failure;
//请求验证码
+ (void)requestVerifyCodeForPhone:(NSString *)phone
                          success:(void(^)(NSString *code, NSString *message))success
                          failure:(void(^)(NSError *error))failure;
//更改密码
+ (void)modifyPassword:(RegisterModel *)newPassWord
               success:(void(^)(NSString *tip))success
               failure:(void(^)(NSError *error))failure;
// 注销用户
+ (void)logOutUserSuccess:(void(^)(NSString *tip))success
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
// 爆料
+ (void)requestBreakNewsPrivate:(BOOL)isPrivat
                           page:(NSInteger)page
                        success:(void(^)(NSInteger page, NSInteger total, NSArray *itemList))success
                        failure:(void(^)(NSError *error))failure;
//绑定手机号码
+ (void)bindPhoneNumber:(NSString *)number
                   code:(NSString *)code
                success:(void(^)(NSString *tip))success
                failure:(void(^)(NSError *error))failure;
//提交评论
+ (void)commitComment:(NSString *)content
                 dict:(NSDictionary *)dict
              success:(void(^)(NSString *tip))success
              failure:(void(^)(NSError *error))failure;
//移除收藏
+ (void)removeCollectItem:(NSDictionary *)dict
                  success:(void(^)(NSString *tip))success
                  failure:(void(^)(NSError *error))failure;
// 添加收藏
+ (void)collectItem:(NSDictionary *)dict
            success:(void(^)(NSString *tip))success
            failure:(void(^)(NSError *error))failure;
// 检测是否收藏
+ (void)checkHasCollectedItem:(NSDictionary *)dict
                      success:(void(^)(BOOL isCollected))success
                      failure:(void(^)(NSError *error))failure;
// 评论列表
+ (void)requestCommentList:(NSInteger)globalId
                      page:(NSInteger)page
                   success:(void(^)(NSInteger page, NSArray *commentList))success
                   failure:(void(^)(NSError *error))failure;

@end
