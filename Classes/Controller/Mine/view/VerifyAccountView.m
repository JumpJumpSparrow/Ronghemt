//
//  VerifyAccountView.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/23.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "VerifyAccountView.h"
#import "InputView.h"
#import <WebKit/WebKit.h>

@interface VerifyAccountView ()<VerifyDelegate>

@property (nonatomic, strong) InputView *accountView;
@property (nonatomic, strong) InputView *veriyCode;
@property (nonatomic, strong) InputView *passwordView;
@property (nonatomic, strong) InputView *repassWordView;
@end

@implementation VerifyAccountView

- (InputView *)accountView {
    if (_accountView == nil) {
        _accountView = [[InputView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44.0f) placeholder:@"请输入手机号码"];
        _accountView.keyboardType = UIKeyboardTypeNumberPad;
        _accountView.lengthLimit = 11;
        _accountView.index = 1;
    }
    return _accountView;
}

- (InputView *)veriyCode {
    if (_veriyCode == nil) {
        _veriyCode = [[InputView alloc] initWithFrame:CGRectMake(0, self.accountView.bottom, self.width, 44.0f) placeholder:@"请输入短信验证码"];
        _veriyCode.keyboardType = UIKeyboardTypeNumberPad;
        _veriyCode.isVerify = YES;
        _veriyCode.lengthLimit = 4;
        _veriyCode.index = 2;
    }
    return _veriyCode;
}

- (InputView *)passwordView {
    if (_passwordView == nil) {
        _passwordView = [[InputView alloc] initWithFrame:CGRectMake(0, self.veriyCode.bottom, self.width, 44.0f) placeholder:@"请输入密码"];
        _passwordView.keyboardType = UIKeyboardTypeDefault;
        _passwordView.lengthLimit = 16;
        _passwordView.isSecureText = YES;
        _passwordView.index = 3;
    }
    return _passwordView;
}

- (InputView *)repassWordView {
    if (_repassWordView == nil) {
        _repassWordView = [[InputView alloc] initWithFrame:CGRectMake(0, self.passwordView.bottom, self.width, 44.0f) placeholder:@"请再次输入密码"];
        _repassWordView.keyboardType = UIKeyboardTypeDefault;
        _repassWordView.lengthLimit = 16;
        _repassWordView.isSecureText = YES;
        _repassWordView.index = 4;
    }
    return _repassWordView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    CGRect suitFrame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH, 44.0f * 4);
    self = [super initWithFrame:suitFrame];
    [self addSubview:self.accountView];
    [self addSubview:self.veriyCode];
    [self addSubview:self.passwordView];
    [self addSubview:self.repassWordView];
    return self;
}

- (void)didInputText:(NSString *)text index:(NSInteger)index {
    switch (index) {
        case 1:
            self.account.phone = text;
            break;
        case 2:
            self.account.code = text.integerValue;
            break;
        case 3:
            self.account.password = text;
            break;
        case 4:
            self.account.repassword = text;
            break;
        default:
            break;
    }
}

- (void)verifyTheAccount {
    if ([self.delegate respondsToSelector:@selector(verifyTheAccount)]) {
        [self.delegate verifyTheAccount];
    }
}

@end
