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
    self.view.backgroundColor = [self randomColor];
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

- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
}

- (void)dealloc {
    
    if (self.hud) [self.hud hideAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
