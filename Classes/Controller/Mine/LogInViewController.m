//
//  LogInViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "LogInViewController.h"
#import <YYKit/UIView+YYAdd.h>

@interface TitleInputView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) CALayer *line;

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
        _inputField.delegate = self;
    }
    return _inputField;
}

- (CALayer *)line {
    if (_line == nil) {
        _line = [[CALayer alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor].CGColor;
    }
    return _line;
}

- (instancetype)initWith:(NSString *)title placeholder:(NSString *)holder frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputField];
    [self.layer addSublayer:self.line];
    self.titleLabel.text = title;
    self.inputField.placeholder = holder;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.titleLabel.width/2.0f + 20, self.height/2.0f);
    self.inputField.frame = CGRectMake(0, 0, self.width - self.titleLabel.right - 40.0f, 30);
    self.inputField.center = CGPointMake(self.titleLabel.right + self.inputField.width / 2.0f, self.height/2.0f);
    self.line.frame = CGRectMake(0, self.height - 0.5f, self.width, 0.5f);
}

@end

@interface LogInViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TitleInputView *account;
@property (nonatomic, strong) TitleInputView *password;
@property (nonatomic, strong) UIButton *logInButton;
@property (nonatomic, strong) UIButton *registButton;
@property (nonatomic, strong) UIButton *forgotButton;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户登录";
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
