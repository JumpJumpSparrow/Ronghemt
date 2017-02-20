//
//  MCFTools.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFTools.h"
#import "MCFAlertController.h"
#import <YYKit.h>

@implementation MCFTools

+ (void)showAlert:(NSString *)alert to:(UIViewController *)target completion:(void (^)())completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MCFAlertController *alertVC = [MCFAlertController alertControllerWithTitle:@"提示" message:alert preferredStyle:UIAlertControllerStyleAlert];
        alertVC.messageColor = [UIColor colorWithHexString:AppColorSelected];
        alertVC.tintColor = [UIColor colorWithHexString:AppColorSelected];
        MCFAlertAction *action = [MCFAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:NULL];
        [alertVC addAction:action];
        [target presentViewController:alertVC animated:YES completion:completion];
    });
}

+ (void)showAlert:(NSString *)alert to:(UIViewController *)target {
    
}
@end
