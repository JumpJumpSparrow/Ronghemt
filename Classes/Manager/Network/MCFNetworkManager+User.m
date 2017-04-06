//
//  MCFNetworkManager+User.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFNetworkManager+User.h"
#import "MCFTools.h"
#import "GTMBase64.h"

static NSString *LogIn            = @"login.php";
static NSString *Regist           = @"register.php";
static NSString *logOut           = @"logout.php";
static NSString *checkSession     = @"login_verify.php";
static NSString *verifyCode       = @"code.php";
static NSString *registThird      = @"third_register.php";
static NSString *loginThird       = @"third_login.php";
static NSString *modifyPass       = @"find_passwd.php";
static NSString *uploadFile       = @"file_upload.php";
static NSString *updateProfile    = @"userinfo_modify.php";
static NSString *bindPhone        = @"bind_phone.php";
static NSString *rebindPhone      = @"unbind.php";
static NSString *updateUserInfo   = @"get_userinfo.php";
static NSString *feedback         = @"feedback.php";
static NSString *breakNews        = @"baoliao_list.php";
static NSString *publishBreakNews = @"baoliao.php";
static NSString *commitComment    = @"comment.php";
static NSString *removeCollect    = @"del_collect.php";
static NSString *collectItem      = @"collect.php";
static NSString *chechCollect     = @"has_collect.php";
static NSString *commentList      = @"comment_list.php";

@implementation MCFNetworkManager (User)

+ (void)loginWithUser:(RegisterModel *)user
              success:(void (^)(MCFUserModel *, NSString *))success
              failure:(void (^)(NSError *))failure {

    NSMutableDictionary *paramDict = [user mj_keyValues];
    [paramDict setValue:[MCFConfigure cfg].siteCode forKey:@"siteCode"];
    [[MCFNetworkManager sharedManager] POST:LogIn
                                 parameters:paramDict
                                    success:^(NSUInteger taskId, id responseObject) {
                                        NSDictionary *dataDict = [responseObject objectForKey:@"result"];
                                        NSString *tip = [responseObject objectForKey:@"message"];
                                        MCFUserModel *user = [MCFUserModel mj_objectWithKeyValues:dataDict];
                                        [MCFTools saveLoginUser:user];
                                        if (success) {
                                            success(user, tip);
                                        }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
}

+ (void)loginWithThird:(NSDictionary *)third
               success:(void (^)(MCFUserModel *, NSString *))success
               failure:(void (^)(NSError *))failure {
    [[MCFNetworkManager sharedManager] POST:loginThird
                                 parameters:third
                                    success:^(NSUInteger taskId, id responseObject) {
                                        NSDictionary *dataDict = [responseObject objectForKey:@"result"];
                                        NSString *tip = [responseObject objectForKey:@"message"];
                                        MCFUserModel *user = [MCFUserModel mj_objectWithKeyValues:dataDict];
                                        [MCFTools saveLoginUser:user];
                                        if (success) {
                                            success(user, tip);
                                        }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
}

+ (void)registerUser:(RegisterModel *)user
             success:(void (^)(MCFUserModel *, NSString *))success
             failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *paramDict = [user mj_keyValues];
    [paramDict setValue:[MCFConfigure cfg].siteCode forKey:@"siteCode"];
    [[MCFNetworkManager sharedManager] POST:Regist
                                 parameters:paramDict
                                    success:^(NSUInteger taskId, id responseObject) {
                                        NSDictionary *dataDict = [responseObject objectForKey:@"result"];
                                        NSString *tip = [responseObject objectForKey:@"message"];
                                        MCFUserModel *user = [MCFUserModel mj_objectWithKeyValues:dataDict];
                                        if (success) {
                                            success(user, tip);
                                        }
                                    } failure:^(NSUInteger taskId, NSError *error) {
                                        if (failure) {
                                            failure (error);
                                        }
                                    }];
}

+ (void)requestVerifyCodeForPhone:(NSString *)phone
                          success:(void (^)(NSString *, NSString *))success
                          failure:(void (^)(NSError *))failure {
    NSDictionary *dict = @{@"phone" : phone};
    [[MCFNetworkManager sharedManager] GET:verifyCode
                                parameters:dict
                                   success:^(NSUInteger taskId, id responseObject) {
                                       NSString *code = [responseObject objectForKey:@"code"];
                                       NSString *message = [responseObject objectForKey:@"message"];
                                       if (success) {
                                           success(code, message);
                                       }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
}

+ (void)modifyPassword:(RegisterModel *)newPassWord
               success:(void (^)(NSString *))success
               failure:(void (^)(NSError *))failure {
    
    NSDictionary *dict = @{ @"phone" : newPassWord.phone,
                            @"code" : @(newPassWord.code),
                            @"new" : newPassWord.password,
                            @"confirm" : newPassWord.re_password,
                            @"siteCode" : [MCFConfigure cfg].siteCode
                           };
    [[MCFNetworkManager sharedManager] GET:modifyPass
                                parameters:dict
                                   success:^(NSUInteger taskId, id responseObject) {
                                       NSString *message = [responseObject objectForKey:@"message"];
                                       if (success) {
                                           success(message);
                                       }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
}

+ (void)logOutUserSuccess:(void (^)(NSString *))success
                  failure:(void (^)(NSError *))failure {
    NSDictionary *dict = @{@"session" : [MCFTools getLoginUser] .session};
    [[MCFNetworkManager sharedManager] GET:logOut
                                parameters:dict
                                   success:^(NSUInteger taskId, id responseObject) {
                                       NSString *message = [responseObject objectForKey:@"message"];
                                       if (success) {
                                           success(message);
                                       }
                                   } failure:^(NSUInteger taskId, NSError *error) {
                                       if (failure) {
                                           failure (error);
                                       }
                                   }];
}

+ (void)verifySession:(void (^)())valid
              invalid:(void (^)())invalid
              failure:(void (^)(NSError *))failure {
    if (![MCFTools isLogined]) {
        return;
    }
    NSDictionary *dict = @{@"session" : [MCFTools getLoginUser] .session,
                           @"siteCode" : [MCFConfigure cfg].siteCode
                           };
    [[MCFNetworkManager sharedManager] GET:checkSession
                                parameters:dict
                                   success:^(NSUInteger taskId, id responseObject) {
                                       NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
                                       if (status == 1 && valid) {
                                           valid();
                                       } else if (status == 0 && invalid) {
                                           [MCFTools clearLoginUser];
                                           invalid();
                                       }
                                   } failure:^(NSUInteger taskId, NSError *error) {
                                       if (failure) {
                                           failure (error);
                                       }
                                   }];
}

+ (void)updateUserProfile:(MCFUserModel *)user
                  success:(void (^)(NSString *))success
                  failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *dict = [user mj_keyValues];
    [dict setValue:[MCFConfigure cfg].siteCode forKey:@"siteCode"];
    [[MCFNetworkManager sharedManager] POST:updateProfile
                                 parameters:dict
                                    success:^(NSUInteger taskId, id responseObject) {
                                        
                                        NSString *tip = [responseObject objectForKey:@"message"];
                                        if (success) {
                                            success(tip);
                                        }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
}

+ (void)bindPhoneNumber:(NSString *)number
                   code:(NSString *)code
                success:(void (^)(NSInteger, NSString *))success
                failure:(void (^)(NSError *))failure {
    
    if (number.length == 0 || code.length == 0) return;
    MCFUserModel *user = [MCFTools getLoginUser];
    NSDictionary *dict = @{@"phone" : number ,
                           @"code" : code,
                           @"session" : user.session,
                           @"siteCode" : [MCFConfigure cfg].siteCode
                           };
    
    [[MCFNetworkManager sharedManager] POST:bindPhone parameters:dict
                                    success:^(NSUInteger taskId, id responseObject) {
                                        
                                        NSString *sting = [responseObject objectForKey:@"message"];
                                        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
                                        if (success) {
                                            success(status, sting);
                                        }
                                    } failure:^(NSUInteger taskId, NSError *error) {
                                        if (failure) {
                                            failure(error);
                                        }
                                    }];
}

+ (void)rebindPhoneSuccess:(void (^)(NSInteger, NSString *))success
                   failure:(void (^)(NSError *))failure {
    
    MCFUserModel *user = [MCFTools getLoginUser];
    NSDictionary *dict = @{@"type" : @(1) ,
                           @"session" : user.session,
                           @"siteCode" : [MCFConfigure cfg].siteCode
                           };
    
    [[MCFNetworkManager sharedManager] POST:rebindPhone
                                 parameters:dict
                                    success:^(NSUInteger taskId, id responseObject) {
                                        
                                        NSString *sting = [responseObject objectForKey:@"message"];
                                        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
                                        if (success) {
                                            success(status, sting);
                                        }
                                    } failure:^(NSUInteger taskId, NSError *error) {
                                        if (failure) {
                                            failure(error);
                                        }
                                    }];

}

+ (void)feedBack:(NSString *)content
         contact:(NSString *)contact
         success:(void (^)(NSString *))success
         failure:(void (^)(NSError *))failure {

    if (content.length == 0) return;
    MCFUserModel *user = [MCFTools getLoginUser];
    NSDictionary *dict = @{@"contact" : contact == nil ? @"null" :  contact,
                           @"content" : content,
                           @"session" : user.session,
                           @"siteCode" : [MCFConfigure cfg].siteCode
                           };
    
    [[MCFNetworkManager sharedManager] POST:feedback parameters:dict
                                    success:^(NSUInteger taskId, id responseObject) {
                                        
                                        NSString *sting = [responseObject objectForKey:@"message"];
                                        if (success) {
                                            success(sting);
                                        }
                                    } failure:^(NSUInteger taskId, NSError *error) {
                                        if (failure) {
                                            failure(error);
                                        }
                                    }];
}

+ (void)requestBreakNewsPrivate:(BOOL)isPrivat
                           page:(NSInteger)page
                        success:(void (^)(NSInteger, NSInteger, NSArray *))success
                        failure:(void (^)(NSError *))failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (isPrivat && [MCFTools isLogined]) {
        [dict setObject:[MCFTools getLoginUser].session forKey:@"session"];
    }
    [dict setValue:[MCFConfigure cfg].siteCode forKey:@"siteCode"];
    [dict setValue:@(page) forKey:@"page"];
    [[MCFNetworkManager sharedManager] GET:breakNews
                                parameters:dict
                                   success:^(NSUInteger taskId, id responseObject) {
        
                                       NSDictionary *dict = [responseObject objectForKey:@"result"];
                                       NSInteger page = [[dict objectForKey:@"page"] integerValue];
                                       NSInteger total = [[dict objectForKey:@"total"] integerValue];
                                       NSArray *items = [dict objectForKey:@"list"];
                                       
                                       NSArray *data = [BreakNews mj_objectArrayWithKeyValuesArray:items];
                                       if (success) {
                                           success(page, total, data);
                                       }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)publishBreakNews:(NSDictionary *)news
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSError *))failure {
    [[MCFNetworkManager sharedManager] POST:publishBreakNews
                                 parameters:news
                                    success:^(NSUInteger taskId, id responseObject) {
                                        NSString *sting = [responseObject objectForKey:@"message"];
                                        if (success) {
                                            success(sting);
                                        }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)commitComment:(NSString *)content
                 dict:(NSDictionary *)dict
              success:(void (^)(NSString *))success
              failure:(void (^)(NSError *))failure {
    if (content.length == 0 || dict == nil) {
        return;
    }
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:[MCFTools getLoginUser].session forKey:@"session"];
    [paramDict setValue:dict[@"title"] forKey:@"title"];
    [paramDict setValue:dict[@"globalId"] forKey:@"globalid"];
    [paramDict setValue:content forKey:@"content"];
    [paramDict setValue:dict[@"loadUrl"] forKey:@"url"];
    [paramDict setValue:dict[@"siteCode"] ? dict[@"siteCode"] : [MCFConfigure cfg].siteCode forKey:@"siteCode"];
    
    [[MCFNetworkManager sharedManager] POST:commitComment
                                 parameters:paramDict
                                    success:^(NSUInteger taskId, id responseObject) {
        
        NSString *sting = [responseObject objectForKey:@"message"];
        if (success) {
            success(sting);
        }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)collectItem:(NSDictionary *)dict
            success:(void (^)(NSString *))success
            failure:(void (^)(NSError *))failure {
    if (dict == nil) {
        return;
    }
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:[MCFTools getLoginUser].session forKey:@"session"];
    [paramDict setValue:dict[@"title"] forKey:@"title"];
    [paramDict setValue:dict[@"globalId"] forKey:@"id"];
    [paramDict setValue:@([[dict objectForKey:@"conType"] integerValue]) forKey:@"type"];
    [paramDict setValue:dict[@"loadUrl"] forKey:@"url"];
    [paramDict setValue:dict[@"siteCode"] ? dict[@"siteCode"] : [MCFConfigure cfg].siteCode forKey:@"siteCode"];
    
    [[MCFNetworkManager sharedManager] POST:collectItem parameters:paramDict success:^(NSUInteger taskId, id responseObject) {
        
        NSString *sting = [responseObject objectForKey:@"message"];
        if (success) {
            success(sting);
        }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)removeCollectItem:(NSDictionary *)dict
                  success:(void (^)(NSString *))success
                  failure:(void (^)(NSError *))failure {
    if (dict == nil) {
        return;
    }
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:[MCFTools getLoginUser].session forKey:@"session"];
    [paramDict setValue:dict[@"globalId"] forKey:@"globalid"];
    [paramDict setValue:dict[@"siteCode"] ? dict[@"siteCode"] : [MCFConfigure cfg].siteCode forKey:@"siteCode"];
    
    [[MCFNetworkManager sharedManager] POST:removeCollect
                                 parameters:paramDict
                                    success:^(NSUInteger taskId, id responseObject) {
        
        NSString *sting = [responseObject objectForKey:@"message"];
        if (success) {
            success(sting);
        }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)checkHasCollectedItem:(NSDictionary *)dict
                      success:(void (^)(BOOL))success
                      failure:(void (^)(NSError *))failure {
    if (dict == nil) {
        return;
    }
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:[MCFTools getLoginUser].session forKey:@"session"];
    [paramDict setValue:dict[@"globalId"] forKey:@"id"];
    [paramDict setValue:dict[@"siteCode"] ? dict[@"siteCode"] : [MCFConfigure cfg].siteCode forKey:@"siteCode"];
    [[MCFNetworkManager sharedManager] POST:chechCollect
                                 parameters:paramDict
                                    success:^(NSUInteger taskId, id responseObject) {
                                        
                                        NSInteger isCollected = [[responseObject objectForKey:@"status"] integerValue];
                                        if (success) {
                                            success(isCollected == 1);
                                        }
                                    } failure:^(NSUInteger taskId, NSError *error) {
                                        if (failure) {
                                            failure(error);
                                        }
                                    }];
}

+ (void)requestCommentList:(NSDictionary *)infoDict
                      page:(NSInteger)page
                   success:(void (^)(NSInteger, NSArray *))success
                   failure:(void (^)(NSError *))failure {
    if (page == 0) {
        return;
    }
    NSDictionary *dict = @{
                           @"globalid" : @([infoDict[@"globalId"] integerValue]),
                           @"siteCode" : infoDict[@"siteCode"] ? infoDict[@"siteCode"] : [MCFConfigure cfg].siteCode,
                           @"page" : @(page),
                           @"per_num" : @(20)
                           };
    
    [[MCFNetworkManager sharedManager] GET:commentList
                                parameters:dict
                                   success:^(NSUInteger taskId, id responseObject) {
        
                                       NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                                       NSInteger page = [resultDict[@"page"] integerValue];
                                       NSArray *dataList = resultDict[@"list"];
                                       NSArray *modleList = [CommentModel mj_objectArrayWithKeyValuesArray:dataList];
                                       if (success) {
                                           success(page, modleList);
                                       }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)uploadImages:(NSArray <UIImage *>*)imageList
          completion:(void (^)(NSArray<NSString *> *urls))completion{
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray:imageList];
    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:0];
    [self uploadImages:imageArray
                  urls:urlArray
            completion:^(NSArray<NSString *> *urlList) {
                if (completion) {
                    completion(urlList);
                }
            }];
}

+ (void)uploadImages:(NSMutableArray <UIImage *>*)images
                urls:(NSMutableArray *)urlArray
          completion:(void(^)(NSArray <NSString *>*))completion{
    
    if (images.count == 0) {
        NSLog(@"所有图片上传完毕");
        //返回URL
        if (completion) {
            completion(urlArray);
        }
        return;
    }
    UIImage *image = [images firstObject];
    [images removeObject:image];
    
    [MCFNetworkManager uploadFile:image success:^(NSString *tip) {
        
        [urlArray addObject:tip];
        [self uploadImages:images
                      urls:urlArray
                completion:completion];
        
    } failure:^(NSError *error) {
        
        [self uploadImages:images
                      urls:urlArray
                completion:completion];
    }];
}

+ (void)upLoadImage:(UIImage *)image
            success:(void (^)(NSString *))success
            failure:(void (^)(NSError *))failure {
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    //NSString *fileStr = [GTMBase64 stringByEncodingData:data];
    NSDictionary *dict = @{@"file" : data};
    
    [[MCFNetworkManager sharedManager] POST:uploadFile parameters:dict success:^(NSUInteger taskId, id responseObject) {
        
        NSString *sting = [responseObject objectForKey:@"message"];
        if (success) {
            success(sting);
        }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)uploadFile:(NSObject *)file
           success:(void (^)(NSString *))success
           failure:(void (^)(NSError *))failure {
    if(file == nil) return;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
    //2.上传文件
    NSString *url = [NSString stringWithFormat:@"http://user.dev.ctvcloud.com/api/%@",uploadFile];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@" ", @"file", nil];
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传文件参数
        NSData *data = UIImageJPEGRepresentation((UIImage *)file, 0.3);
        [formData appendPartWithFileData:data name:@"file" fileName:@"imagefile.jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf%%", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        NSDictionary *dict = responseObject[@"result"];
        NSString *sting = [dict objectForKey:@"url"];
        if (success) {
            success(sting);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败  
        NSLog(@"请求失败：%@",error);
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)shareAppToFriendsSuccess:(void (^)(NSDictionary *))success
                         failure:(void (^)(NSError *))failure {

    [[MCFNetworkManager sharedManager] GET:[MCFConfigure cfg].shareUrl
                                parameters:nil
                                   success:^(NSUInteger taskId, id responseObject) {
                                       NSString *url = responseObject[@"url"];
                                       if (url.length > 0 || success) {
                                           NSDictionary *dic = @{
                                                                 @"loadUrl" : responseObject[@"url"] ? responseObject[@"url"] : @"  ",
                                                                 @"title" : responseObject[@"summary"] ? responseObject[@"summary"] : @"  ",
                                                                 @"picPath" : responseObject[@"pic"] ? responseObject[@"pic"] : @"  "
                                                                 };
                                           
                                           success(dic);
                                       }
    } failure:^(NSUInteger taskId, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
