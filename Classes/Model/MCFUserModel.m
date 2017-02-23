//
//  MCFUserModel.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFUserModel.h"

@implementation MCFUserModel
MJCodingImplementation // 归档、解归档

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"username" : @"username",
               @"avatar" : @"avatar",
                @"email" : @"email",
                @"phone" : @"phone",
            @"sessionid" : @"sessionid",
               @"userId" : @"id"
             };
}

@end
