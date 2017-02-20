//
//  MCFNetworkManager+NaVi.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFNetworkManager+NaVi.h"

@implementation MCFNetworkManager (NaVi)

+ (void)requestNaviTypeSuccess:(void (^)(NSArray *))sucess failure:(void (^)(NSString *))failure {
    [[MCFNetworkManager sharedManager] GET: [MCFConfigure cfg].NaviType
                                 parameters:nil success:^(NSUInteger taskId, id responseObject) {
                                     NSLog(@"%@", responseObject);
                                 } failure:^(NSUInteger taskId, NSError *error) {
                                     
                                 }];
}
@end
