//
//  CommentModel.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
           @"username" : @"username",
               @"date" : @"date",
            @"content" : @"content",
          @"commentId" : @"id",
             @"userid" : @"userid",
             @"avatar" : @"avatar",
             @"avatar" : @"avatar"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"reply" : @"CommentModel" };
}
@end
