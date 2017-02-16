//
//  BaseViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"
#import <MBProgressHUD.h>

@interface BaseViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)showLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    });
}

- (void)showTip:(NSString *)tip{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.hud) [self.hud hideAnimated:NO];
        self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.label.text = tip;
        [self.hud hideAnimated:YES afterDelay:3.0f];
    });
}

- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.hud) [self.hud hideAnimated:YES];
    });
}

- (void)dealloc {
    
    if (self.hud) [self.hud hideAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
