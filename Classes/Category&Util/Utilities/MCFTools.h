//
//  MCFTools.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCFUserModel;
@interface MCFTools : NSObject

+ (id)getObjectForKey:(NSString *)key;

+ (instancetype)sharedInstance;
+ (BOOL)isLogined;
+ (MCFUserModel *)getLoginUser;
+ (void)saveLoginUser:(MCFUserModel *)bean;
+ (void)clearLoginUser;

+ (NSString *)securityText:(NSString *)text;
+ (BOOL)verifyPassword:(NSString *)passWord lengthLimit:(NSInteger)limit;
@end
