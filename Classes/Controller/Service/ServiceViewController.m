//
//  ServiceViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.contentWebView.backgroundColor = [UIColor whiteColor];
    self.contentWebView.scrollView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
