//
//  MCFCacheUtil.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/27.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPathLibraryDirectory         ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject])
#define kPathDocumentDirectory        ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])
#define kPathPreferencePanesDirectory ([NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject])
#define kPathLibraryCacheDirectory    ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])

@interface MCFCacheUtil : NSObject


+ (double)cacheSizeInPath:(NSString *)path;


+ (void)cleanCacheInPath:(NSString *)path;

+ (double)cacheSizeInTemporaryDirectory;

+ (void)cleanCacheInTemporaryDirectory;


+ (double)usableSpaceInDevice;

+ (NSString *)mcf_persistentPath;

@end
