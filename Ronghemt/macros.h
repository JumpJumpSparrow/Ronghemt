//
//  macros.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#ifndef macros_h
#define macros_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define	APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define APP_VERSION_EQUAL_TO(v) ([APP_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)

#define APP_VERSION_GREATER_THAN(v) ([APP_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
#define APP_VERSION_NOT_LESS_THAN(v) ([APP_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)

#define APP_VERSION_LESS_THAN(v) ([APP_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#define APP_VERSION_NOT_GREATER_THAN(v) ([APP_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
#define SYSTEM_VERSION_EQUAL_TO(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_NOT_LESS_THAN(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_NOT_GREATER_THAN(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)

#ifdef CGFLOAT_IS_DOUBLE
#define GF_EPSILON DBL_EPSILON
#define GF_MIN DBL_MIN
#else
#define GF_EPSILON FLT_EPSILON
#define GF_MIN FLT_MIN
#endif

#define gf_equal(a,b) (fabs((a) - (b)) < GF_EPSILON)
#define gf_equalZero(a) (fabs(a) < GF_EPSILON)

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* macros_h */
