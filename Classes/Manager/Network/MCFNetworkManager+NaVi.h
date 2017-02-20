//
//  MCFNetworkManager+NaVi.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFNetworkManager.h"

@interface MCFNetworkManager (NaVi)

+ (void)requestNaviTypeSuccess:(void(^)(NSArray *channels))sucess failure:(void(^)(NSString *tips))failure;

@end
