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

+ (void)registerUser:(RegisterModel *)user success:(void(^)(MCFUserModel *user, NSString *tip))success failure:(void(^)(NSError *error))failure;

+ (void)loginWithUser:(RegisterModel *)user success:(void(^)(MCFUserModel *user, NSString *tip))success failure:(void(^)(NSError *error))failure;
@end
