//
//  MCFNetworkManager+User.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFNetworkManager+User.h"
#import "MCFTools.h"

static NSString *LogIn        = @"login.php";
static NSString *Regist       = @"user/register";

@implementation MCFNetworkManager (User)

+ (void)loginWithUser:(RegisterModel *)user
              success:(void (^)(MCFUserModel *, NSString *))success
              failure:(void (^)(NSError *))failure {

    NSDictionary *paramDict = [user mj_keyValues];
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

+ (void)registerUser:(RegisterModel *)user
             success:(void (^)(MCFUserModel *, NSString *))success
             failure:(void (^)(NSError *))failure {
    
    NSDictionary *paramDict = [user mj_keyValues];
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

@end
