//
//  MCFUserModel.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFBaseModel.h"

@interface MCFUserModel : MCFBaseModel

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, copy) NSString *session;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *id_card;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *callback;
@end
