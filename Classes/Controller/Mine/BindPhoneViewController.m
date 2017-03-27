//
//  BindPhoneViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/10.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "InputView.h"
#import "MCFUserModel.h"
#import "MCFNetworkManager+User.h"
#import <YYKit.h>
#import "RegisterModel.h"

@interface BindPhoneViewController ()<VerifyDelegate>

@property (nonatomic, strong) InputView *phoneView;
@property (nonatomic, strong) InputView *codeView;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) RegisterModel *userRegist;
@end

@implementation BindPhoneViewController

- (InputView *)phoneView {
    if (_phoneView == nil) {
        _phoneView = [[InputView alloc] initWithFrame:CGRectMake(0, 64.0f, SCREEN_WIDTH, 44.0f) placeholder:@"请输入手机号码"];
        _phoneView.lengthLimit = 11;
        _phoneView.delegate = self;
        _phoneView.index = 1;
        _phoneView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneView;
}

- (InputView *)codeView {
    if (_codeView == nil) {
        _codeView = [[InputView alloc] initWithFrame:CGRectMake(0, self.phoneView.bottom, SCREEN_WIDTH, 44.0f) placeholder:@"请输入短信验证码"];
        _codeView.isVerify = YES;
        _codeView.lengthLimit = 4;
        _codeView.delegate = self;
        _codeView.index = 2;
        _codeView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeView;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 162.0f, SCREEN_WIDTH - 20, 40)];
        [_commitButton setTitle:@"登录" forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage imageNamed:@"commit_bg"] forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(didSelectCommitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"绑定手机号";
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.commitButton];
    self.userRegist = [[RegisterModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)didSelectCommitButton {
    
    if (self.phoneView.inputField.text.length == 0) {
        [self showTip:@"请输入手机号码"];
        return;
    }
    if (self.codeView.inputField.text.length == 0) {
        [self showTip:@"请输入验证码"];
        return;
    }
    [self showLoading];
    [MCFNetworkManager bindPhoneNumber:self.userRegist.phone
                                  code:[NSString stringWithFormat:@"%ld",self.userRegist.code]
                               success:^(NSInteger staus, NSString *tip) {
                                   [self hideLoading];
                                   [self showTip:tip];
                                   if (staus == 1) {
                                       MCFUserModel *user = [MCFTools getLoginUser];
                                       user.phone = self.userRegist.phone;
                                       [MCFTools saveLoginUser:user];
                                       
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           [self.navigationController popViewControllerAnimated:YES];
                                       });
                                   }
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showTip:@"网络错误"];
    }];
    
}

- (void)verifyTheAccount:(UIButton *)sender {
    
    [MCFNetworkManager requestVerifyCodeForPhone:self.userRegist.phone
                                         success:^(NSString *code, NSString *message) {
        [self showTip:message];
        NSLog(@"%@",code);
    } failure:^(NSError *error) {
        [self showTip:@"网络错误"];
    }];
}

- (void)didInputText:(NSString *)text index:(NSInteger)index {
    
    if (index == 1) {
        self.userRegist.phone = text;
    } else if (index == 2) {
        self.userRegist.code = [text integerValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
