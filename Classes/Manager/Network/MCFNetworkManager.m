//
//  MCFNetworkManager.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFNetworkManager.h"

@implementation MCFNetworkManager

- (NSUInteger)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSUInteger, id))success failure:(void (^)(NSUInteger, NSError *))failure {
   
    NSString *requestUrlString = [MCFNetworkManager getHost:URLString];
    NSUInteger taskId = [super POST:requestUrlString
                         parameters:parameters
                            success:^(NSUInteger taskId, id responseObject){
                                if (success) {
                                    success(taskId, responseObject);
                                }
                            }
                            failure:^(NSUInteger taskId, NSError *error) {
                                if (failure) {
                                    failure(taskId, error);
                                }
                            }];
    return taskId;
}

- (NSUInteger)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSUInteger, id))success failure:(void (^)(NSUInteger, NSError *))failure {
    
    NSString *requestUrlString = [MCFNetworkManager getHost:URLString];
    
    NSUInteger taskId = [super GET:requestUrlString
                        parameters:parameters
                           success:^(NSUInteger taskId, id responseObject){
                               if (success) {
                                   success(taskId, responseObject);
                               }
                           }
                           failure:^(NSUInteger taskId, NSError *error) {
                               if (failure) {
                                   failure(taskId, error);
                               }
                           }];
    return taskId;
}

+ (NSString *)getHost:(NSString *)url {
    NSString *requestUrlString = nil;
    if ([[url lowercaseString] hasPrefix:@"http"]) {
        requestUrlString = url;
    } else {
        NSString *host = [MCFConfigure cfg].APPNetHost;
        requestUrlString = [host stringByAppendingPathComponent:url];
    }
    return requestUrlString;
}

@end
