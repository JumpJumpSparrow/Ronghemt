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
#import "MCFNetworkManager.h"
#import <YYKit.h>

@interface BindPhoneViewController ()<VerifyDelegate>

@property (nonatomic, strong) InputView *phoneView;
@property (nonatomic, strong) InputView *codeView;
@property (nonatomic, strong) UIButton *commitButton;
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
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.commitButton];
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
    MCFUserModel *user = [MCFTools getLoginUser];
    user.username = self.phoneView.inputField.text;
}

- (void)verifyTheAccount:(UIButton *)sender {
    
}

- (void)didInputText:(NSString *)text index:(NSInteger)index {

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
