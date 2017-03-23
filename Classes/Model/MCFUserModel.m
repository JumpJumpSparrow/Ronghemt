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
               @"userId" : @"id",
                @"photo" : @"photo",
             @"username" : @"nick"
             };
}

- (void)setNick:(NSString *)nick {
    _username = nick;
}

- (NSString *)nick {
    return _username;
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
}

- (NSString *)photo {
    return _avatar;
}
- (void)setPhoto:(NSString *)photo {
    _avatar = photo;
    
}

- (NSString *)session {
    return _sessionid;
}
- (void)setSession:(NSString *)session {
    _sessionid = session;
}

@end
