//
//  MCFNetworkManager+NaVi.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFNetworkManager+NaVi.h"

@implementation MCFNetworkManager (NaVi)

+ (void)requestNaviTypeSuccess:(void (^)(NSArray *))sucess failure:(void (^)(NSError *))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[MCFNetworkManager sharedManager] GET: [MCFConfigure cfg].APPNaviType
                                 parameters:nil success:^(NSUInteger taskId, id responseObject) {
                                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                     NSArray *tabBarItems = [responseObject objectForKey:@"navigationList"];
                                     NSArray *objcItems = [MCFNaviModel mj_objectArrayWithKeyValuesArray:tabBarItems];
                                     if (sucess) {
                                         sucess(objcItems);
                                     }
                                 } failure:^(NSUInteger taskId, NSError *error) {
                                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}
@end
