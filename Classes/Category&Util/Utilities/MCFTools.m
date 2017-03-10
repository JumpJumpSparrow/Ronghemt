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

+ (NSString *)securityText:(NSString *)text {
    if (text.length < 5) {
        return text;
    }
    NSString *securityText = [NSString stringWithFormat:@"%@*****%@",[text substringToIndex:3],[text substringWithRange:NSMakeRange(text.length - 3, 3)]];
    return securityText;
}

+ (BOOL)verifyPassword:(NSString *)passWord lengthLimit:(NSInteger)limit{
    NSUInteger lengthOfString = passWord.length;
    BOOL hasNumber = NO, hasLatter = NO;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [passWord characterAtIndex:loopIndex];
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character > 47 && character < 58) hasNumber = YES;
        if (character > 54 && character < 91) hasLatter = YES;
        if (character > 96 && character < 123) hasLatter = YES;
    }
    if (!hasNumber || !hasLatter || lengthOfString < limit) {
        return NO;
    } else return YES;
}

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
    } else {
        MCFUserModel *user = [[MCFUserModel alloc] init];
        user.username = @"暂未登录";
        user.avatar = @"http://app1.dev.ctvcloud.com/img/img_moren.png";
        return user;
    }
}

+ (BOOL)isLogined {
    return [MCFTools getLoginUser].userId > 0;
}

+ (void)clearLoginUser {
    [MCFTools setObjectForKey:AppUserKey value:[NSKeyedArchiver archivedDataWithRootObject:[[MCFUserModel alloc] init]]];
}

+ (id)getObjectForKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)setObjectForKey:(NSString*)key value:(id)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

@end
