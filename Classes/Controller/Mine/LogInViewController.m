//
//  LogInViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "LogInViewController.h"
#import <YYKit/UIView+YYAdd.h>
#import "MCFNetworkManager+User.h"
#import "RegistViewController.h"
#import "ModifyPasswordViewController.h"
#import "RegisterModel.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ThirdLogInView.h"

@interface TitleInputView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) CALayer *line;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIReturnKeyType returnType;
@property (nonatomic, assign) BOOL isSecureText;
@property (nonatomic, assign) NSInteger lengthLimit;

- (instancetype)initWith:(NSString *)title placeholder:(NSString *)holder frame:(CGRect)frame;
@end

@implementation TitleInputView

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
}

- (UITextField *)inputField {
    if (_inputField == nil) {
        _inputField = [[UITextField alloc] init];
        _inputField.font = [UIFont systemFontOfSize:15.0f];
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.delegate = self;
    }
    return _inputField;
}

- (CALayer *)line {
    if (_line == nil) {
        _line = [[CALayer alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1].CGColor;
    }
    return _line;
}

- (void)setReturnType:(UIReturnKeyType)returnType {
    self.inputField.returnKeyType = returnType;
}

- (void)setIsSecureText:(BOOL)isSecureText {
    self.inputField.secureTextEntry = isSecureText;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.inputField.keyboardType = keyboardType;
}

- (instancetype)initWith:(NSString *)title placeholder:(NSString *)holder frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputField];
    [self.layer addSublayer:self.line];
    self.titleLabel.text = title;
    self.inputField.placeholder = holder;
    self.lengthLimit = 20;
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSUInteger lengthOfString = toBeString.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [toBeString characterAtIndex:loopIndex]; 
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57 && character < 65) return NO; //
        if (character > 90 && character < 97) return NO;
        if (character > 122) return NO;
        
    }
    if (toBeString.length > self.lengthLimit) {
        return NO;
    }
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.titleLabel.width/2.0f + 20, self.height/2.0f);
    self.inputField.frame = CGRectMake(0, 0, self.width - self.titleLabel.right - 40.0f, 30);
    self.inputField.center = CGPointMake(self.titleLabel.right + self.inputField.width / 2.0f + 20.0f, self.height/2.0f);
    self.line.frame = CGRectMake(10, self.height - 0.5f, self.width - 20, 0.5f);
}

@end

@interface LogInViewController ()<ThirdLogInDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TitleInputView *account;
@property (nonatomic, strong) TitleInputView *password;
@property (nonatomic, strong) UIButton *logInButton;
@property (nonatomic, strong) UIButton *registButton;
@property (nonatomic, strong) UIButton *forgotButton;
@property (nonatomic, strong) ThirdLogInView *thirdLogInView;
@end

@implementation LogInViewController

- (UIButton *)logInButton {
    if (_logInButton == nil) {
        _logInButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 162.0f, SCREEN_WIDTH - 20, 40)];
        [_logInButton setTitle:@"登录" forState:UIControlStateNormal];
        [_logInButton setBackgroundImage:[UIImage imageNamed:@"commit_bg"] forState:UIControlStateNormal];
        [_logInButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logInButton;
}

- (UIButton *)registButton {
    if (_registButton == nil) {
        _registButton = [[UIButton alloc] init];
        [_registButton setTitle:@"用户注册" forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_registButton setTitleColor:[UIColor colorWithHexString:AppColorNormal] forState:UIControlStateNormal];
        [_registButton addTarget:self action:@selector(didSelectRegistButton) forControlEvents:UIControlEventTouchUpInside];
        [_registButton sizeToFit];
        _registButton.frame = CGRectMake(10, self.logInButton.bottom + 20.0f, _registButton.width, _registButton.height);
    }
    return _registButton;
}

- (UIButton *)forgotButton {
    if (_forgotButton == nil){
        _forgotButton = [[UIButton alloc] init];
        [_forgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgotButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _forgotButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_forgotButton addTarget:self action:@selector(didSelectForgotButton) forControlEvents:UIControlEventTouchUpInside];
        [_forgotButton sizeToFit];
        _forgotButton.frame = CGRectMake(SCREEN_WIDTH - _forgotButton.width - 10.f, self.logInButton.bottom + 20.0f, _forgotButton.width, _forgotButton.height);
    }
    return _forgotButton;
}

- (ThirdLogInView *)thirdLogInView {
    if (_thirdLogInView == nil) {
        _thirdLogInView = [[ThirdLogInView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 160.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 160.0f)];
        _thirdLogInView.delegate = self;
    }
    return _thirdLogInView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
    
}

- (void)installUI {
    self.title = @"用户登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.account = [[TitleInputView alloc] initWith:@"账号" placeholder:@"手机号" frame:CGRectMake(0, 64.0f, SCREEN_WIDTH, 44.0f)];
    self.account.keyboardType = UIKeyboardTypeNumberPad;
    self.account.lengthLimit = 11;
    
    self.password = [[TitleInputView alloc] initWith:@"密码" placeholder:@"请输入密码" frame:CGRectMake(0, 64.0f + 44.0f, SCREEN_WIDTH, 44.0f)];
    self.password.returnType = UIReturnKeyDone;
    self.password.isSecureText = YES;
    self.password.lengthLimit = 16;
    self.password.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:self.account];
    [self.view addSubview:self.password];
    
    [self.view addSubview:self.logInButton];
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.forgotButton];
    [self.view addSubview:self.thirdLogInView];
}

- (void)logIn {

    RegisterModel *user = [[RegisterModel alloc] init];
    user.phone = self.account.inputField.text;
    user.password = self.password.inputField.text;
    
    if (user.phone.length == 0) {
        [self showTip:@"请输入账号"];
        return;
    }
    if (user.password.length == 0) {
        [self showTip:@"请输入密码"];
        return;
    }
    
    if (![MCFTools verifyPassword:user.password lengthLimit:8]) {
        [self showTip:@"密码为字母数字组合，长度至少8位"];
        return;
    }
    [MCFNetworkManager loginWithUser:user success:^(MCFUserModel *user, NSString *tip) {
        [self showTip:@"登录成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [self showTip:@"登录失败请稍后再试"];
    }];
}

#pragma mark - thirdDelegate

- (void)didSelectLoginMethod:(NSInteger)index {
    
    UMSocialPlatformType platformType;
    
    switch (index) {
        case 1: // QQ
            platformType = UMSocialPlatformType_QQ;
            break;
            
        case 2: // weibo
            platformType = UMSocialPlatformType_Sina;
            break;
        case 3: // weixin
            platformType = UMSocialPlatformType_WechatSession;
            break;
        default:
            break;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
    
}

- (void)didSelectRegistButton {
    [self.view endEditing:YES];
    RegistViewController *registVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)didSelectForgotButton {
    [self.view endEditing:YES];
    ModifyPasswordViewController *modifyVc = [[ModifyPasswordViewController alloc] init];
    [self.navigationController pushViewController:modifyVc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.account.inputField resignFirstResponder];
    [self.password.inputField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
