//
//  MCFTools.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFTools.h"
#import "MCFUserModel.h"

@implementation MCFTools


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MCFTools *tools;
    dispatch_once(&onceToken, ^{
        tools = [[MCFTools alloc] init];
    });
    return tools;
}

+ (void)saveLoginUser:(MCFUserModel *)bean {
    if (bean) {
        [MCFTools setObjectForKey:AppUserKey value:[NSKeyedArchiver archivedDataWithRootObject:bean]];;
    }
}

+ (MCFUserModel *)getLoginUser {
    NSData *userData = [MCFTools getObjectForKey:AppUserKey];
    if (userData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    } else return [[MCFUserModel alloc] init];
}

+ (BOOL)isLogined {
    return [MCFTools getLoginUser].userId != 0;
}

+ (void)clearLoginUser {
    [MCFTools setObjectForKey:AppUserKey value:[[MCFUserModel alloc] init]];
}

+ (id)getObjectForKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)setObjectForKey:(NSString*)key value:(id)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

@end
