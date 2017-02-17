//
//  MCFConfigure.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCFConfigure : NSObject

@property (nonatomic, readonly, copy) NSString *APPHost;
@property (nonatomic, readonly, copy) NSString *NaviType;
+ (instancetype)cfg;
@end
