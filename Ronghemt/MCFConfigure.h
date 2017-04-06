//
//  MCFConfigure.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCFConfigure : NSObject

@property (nonatomic, readonly, copy) NSString *APPNetHost;
@property (nonatomic, readonly, copy) NSString *APPNaviType;
@property (nonatomic, readonly, copy) NSString *umengAppKey;
@property (nonatomic, readonly, copy) NSString *APPIdWX;
@property (nonatomic, readonly, copy) NSString *AppSecretWX;
@property (nonatomic, readonly, copy) NSString *UMChannel;
@property (nonatomic, readonly, copy) NSString *AppCollect;
@property (nonatomic, readonly, copy) NSString *registProtocol;
@property (nonatomic, readonly, copy) NSString *shareUrl;
@property (nonatomic, readonly, copy) NSString *siteCode;

+ (instancetype)cfg;
@end
