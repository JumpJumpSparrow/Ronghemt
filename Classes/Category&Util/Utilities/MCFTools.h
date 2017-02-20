//
//  MCFTools.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCFTools : NSObject

+ (void)showAlert:(NSString *)alert to:(UIViewController *)target completion:(void(^)())completion;

+ (void)showAlert:(NSString *)alert to:(UIViewController *)target;
@end
