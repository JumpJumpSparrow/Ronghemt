//
//  RegisterModel.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFBaseModel.h"

@interface RegisterModel : MCFBaseModel

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *re_password;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *callback;
@property (nonatomic, assign) NSInteger code;
@end
