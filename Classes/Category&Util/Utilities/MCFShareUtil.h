//
//  MCFShareUtil.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/27.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCFShareUtil : NSObject

+ (void)showShareMenuToShareUrl:(NSString *)url;
+ (void)showShareMenuToShareInfo:(NSDictionary *)infoDict;
@end
