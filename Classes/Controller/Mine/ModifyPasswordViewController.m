//
//  ModifyPasswordViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/22.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "VerifyAccountView.h"
#import "MCFNetworkManager+User.h"

@interface ModifyPasswordViewController ()<VerifyDelegate>

@property (nonatomic, strong) VerifyAccountView *accountView;
@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation ModifyPasswordViewController

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.accountView.bottom + 20.0f, SCREEN_WIDTH - 20, 40)];
        [_commitButton setTitle:@"重置密码" forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage imageNamed:@"commit_bg"] forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.accountView = [[VerifyAccountView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SCREEN_WIDTH, 0)];
    self.accountView.delegate = self;
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.commitButton];
}

- (void)modifyPassword {
    RegisterModel *account = self.accountView.account;
    
    if (account.phone.length == 0) {
        [self showTip:@"请输入手机号码"];
        return;
    }
    if (account.phone.length < 11) {
        [self showTip:@"号码至少为11位"];
        return;
    }
    if (account.code == 0) {
        [self showTip:@"请输入验证码"];
        return;
    }
    if (![MCFTools verifyPassword:account.password lengthLimit:8]) {
        [self showTip:@"密码为字母数字组合，长度至少8位"];
        return;
    }
    if (account.re_password.length == 0) {
        [self showTip:@"请再次输入密码"];
        return;
    }
    if (![account.password isEqualToString:account.re_password]) {
        [self showTip:@"两次密码不一致"];
        return;
    }
    [self showLoading];
    [MCFNetworkManager modifyPassword:account success:^(NSString *tip) {
        [self hideLoading];
        [self showTip:tip];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showTip:@"网络错误"];
    }];
    
}

- (void)verifyTheAccount:(UIButton *)sender {
    RegisterModel *account = self.accountView.account;
    
    if (account.phone.length == 0) {
        [self showTip:@"请输入手机号码"];
        return;
    }
    if (account.phone.length < 11) {
        [self showTip:@"号码至少为11位"];
        return;
    }
    [MCFNetworkManager requestVerifyCodeForPhone:account.phone success:^(NSString *code, NSString *message) {
        [self showTip:message];
        NSLog(@"%@",code);
    } failure:^(NSError *error) {
        [self showTip:@"网络错误"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
