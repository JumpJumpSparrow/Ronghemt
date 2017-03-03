//
//  RegistViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "RegistViewController.h"
#import "VerifyAccountView.h"
#import "MCFNetworkManager+User.h"
static CGFloat ProtocolFont = 13.0f;

@interface RegistViewController ()<VerifyDelegate>

@property (nonatomic, strong) VerifyAccountView *accountView;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *protocolButton;
@end

@implementation RegistViewController

- (UIButton *)checkButton {
    if (_checkButton == nil) {
        _checkButton = [[UIButton alloc] initWithFrame:CGRectMake(self.commitButton.left, self.commitButton.bottom + 10, 20.0f, 20.0f)];
        [_checkButton setImage:[UIImage imageNamed:@"collection_nor"] forState:UIControlStateSelected];
        [_checkButton setImage:[UIImage imageNamed:@"collection_sel"] forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(didSeleCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
        _checkButton.selected = YES;
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:ProtocolFont];
    }
    return _checkButton;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:ProtocolFont];
        _textLabel.text = @"我已阅读并同意";
        [_textLabel sizeToFit];
        _textLabel.center = CGPointMake(self.checkButton.right + _textLabel.width/2.0f + 5, self.checkButton.centerY);
    }
    return _textLabel;
}

- (UIButton *)protocolButton {
    if (_protocolButton == nil) {
        _protocolButton = [[UIButton alloc] init];
        _protocolButton.titleLabel.font = [UIFont systemFontOfSize:ProtocolFont];
        [_protocolButton setTitle:@"《用户协议》" forState:UIControlStateNormal];
        [_protocolButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_protocolButton sizeToFit];
        _protocolButton.center = CGPointMake(self.textLabel.right + _protocolButton.width/2.0f, self.checkButton.centerY);
        [_protocolButton addTarget:self action:@selector(didSelectProtocol) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolButton;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.accountView.bottom + 20.0f, SCREEN_WIDTH - 20, 40)];
        [_commitButton setTitle:@"立即注册" forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage imageNamed:@"commit_bg"] forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(registNewUser) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.accountView = [[VerifyAccountView alloc] initWithFrame:CGRectMake(0, 64.0f, SCREEN_WIDTH, 0)];
    self.accountView.delegate = self;
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.commitButton];
    [self.view addSubview:self.checkButton];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.protocolButton];
}

- (void)verifyTheAccount {
    //请求验证码
}

- (void)registNewUser {
    
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
    if (self.checkButton.selected) {
        [self showTip:@"请同意用户协议"];
        return;
    }
    [self showLoading];
    [MCFNetworkManager registerUser:account success:^(MCFUserModel *user, NSString *tip) {
        [self hideLoading];
        [self showTip:tip];
        if (user.userId > 0) {
            dispatch_after(dispatch_time_delay(2), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}

- (void)didSeleCheckBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.commitButton.enabled = sender.selected;
}

- (void)didSelectProtocol {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
