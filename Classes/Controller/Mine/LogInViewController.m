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

@protocol ThirdLogInDelegate <NSObject>

- (void)didSelectLoginMethod:(NSInteger)index;
@end

@interface ThirdLogInView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *buttonList;
@property (nonatomic, weak) id <ThirdLogInDelegate>delegate;
@end

@implementation ThirdLogInView

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor colorWithHexString:AppColorNormal];
        _titleLabel.text = @"第三方登录";
        [_titleLabel sizeToFit];
        _titleLabel.center = CGPointMake(self.width/2.0f, _titleLabel.height/2.0f);
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self addSubview:self.titleLabel];
    [self installButton];
    return self;
}

- (void)installButton {
    
    NSArray *titleArray = @[@"QQ", @"微博", @"微信"];
    NSArray *imageNameArray = @[@"img_share_qq", @"img_share_sina", @"img_share_weixin"];
    CGFloat width = 80.0f;
    CGFloat margin = 30.f;
    CGFloat gap = (SCREEN_WIDTH - width * 3 - margin * 2)/2.0f;
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [button setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        button.center = CGPointMake(margin + (i + 0.5) * width + gap * i, button.height / 2.0f + 30);
        button.tag = i + 1;
        [button addTarget:self action:@selector(didSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = titleArray[i];
        label.textColor = [UIColor colorWithHexString:AppColorNormal];
        label.font = [UIFont systemFontOfSize:16.0f];
        [label sizeToFit];
        label.center = CGPointMake(button.centerX, button.bottom + label.height / 2.0f + 5);
        [self addSubview:label];
        
        if (i != 1){
            CALayer *line = [[CALayer alloc] init];
            line.backgroundColor = APPGRAY.CGColor;
            line.frame = CGRectMake(0, 0, self.titleLabel.left - 20, 0.5);
            line.center = CGPointMake(button.centerX, self.titleLabel.centerY);
            [self.layer addSublayer:line];
        }
    }
    
}

- (void)didSelectIndex:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didSelectLoginMethod:)]) {
        [self.delegate didSelectLoginMethod:button.tag];
    }
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
    self.account.keyboardType = UIKeyboardTypePhonePad;
    
    self.password = [[TitleInputView alloc] initWith:@"密码" placeholder:@"请输入密码" frame:CGRectMake(0, 64.0f + 44.0f, SCREEN_WIDTH, 44.0f)];
    self.password.returnType = UIReturnKeyDone;
    self.password.isSecureText = YES;
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
    [MCFNetworkManager loginWithUser:nil success:^(MCFUserModel *user, NSString *tip) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - thirdDelegate

- (void)didSelectLoginMethod:(NSInteger)index {
    switch (index) {
        case 1: // QQ
            
            break;
            
        case 2: // weibo
            
            break;
        case 3: // weixin
            
            break;
        default:
            break;
    }
}

- (void)didSelectRegistButton {
    RegistViewController *registVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)didSelectForgotButton {
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