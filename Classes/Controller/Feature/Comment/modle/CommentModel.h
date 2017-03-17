//
//  CommentModel.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFBaseModel.h"

@interface CommentModel : MCFBaseModel

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) NSArray *reply;
@end
