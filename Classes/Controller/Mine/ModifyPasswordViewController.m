//
//  ModifyPasswordViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/22.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "VerifyAccountView.h"

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.accountView = [[VerifyAccountView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SCREEN_WIDTH, 0)];
    self.accountView.delegate = self;
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.commitButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    if (account.password.length == 0) {
        [self showTip:@"请输入密码"];
        return;
    }
    if (account.repassword.length == 0) {
        [self showTip:@"请再次输入密码"];
        return;
    }
    
    if (![account.password isEqualToString:account.repassword]) {
        [self showTip:@"两次密码不一致"];
        return;
    }

}

- (void)verifyTheAccount {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
