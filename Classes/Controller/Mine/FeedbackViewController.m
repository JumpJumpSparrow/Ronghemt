//
//  FeedbackViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "FeedbackViewController.h"
#import <YYKit.h>
#import "MCFNetworkManager+User.h"

@interface TextInputView : UIView

@property (nonatomic, strong) YYTextView *inputView;
@end

@implementation TextInputView

- (YYTextView *)inputView {
    if (_inputView == nil) {
        _inputView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 10, self.width - 20, self.height - 20)];
        _inputView.placeholderText = @"请输入您遇到的问题...";
        _inputView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _inputView.textAlignment = NSTextAlignmentLeft;
        _inputView.font = [UIFont systemFontOfSize:15.0f];
    }
    return _inputView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = 10.0f;
    self.backgroundColor = APPGRAY;
    self.clipsToBounds = YES;
    [self addSubview:self.inputView];
    return self;
}

@end


@interface Textinputbar : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputField;
@end

@implementation Textinputbar

- (UITextField *)inputField {
    if (_inputField == nil) {
        _inputField = [[UITextField alloc] init];
        _inputField.placeholder = @"留下您的联系方式：QQ／邮箱／手机号码";
        _inputField.font = [UIFont systemFontOfSize:13.0f];
        _inputField.delegate = self;
    }
    return _inputField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = 10.0f;
    self.backgroundColor = APPGRAY;
    self.clipsToBounds = YES;
    [self addSubview:self.inputField];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.inputField.frame = CGRectMake(10, 10, self.width - 20, self.height - 20);
}

@end


@interface FeedbackViewController ()<YYTextViewDelegate>

@property (nonatomic, strong) TextInputView *mainInputView;
@property (nonatomic, strong) Textinputbar *inputBar;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation FeedbackViewController

- (TextInputView *)mainInputView {
    if (_mainInputView == nil) {
        _mainInputView = [[TextInputView alloc] initWithFrame:CGRectMake(10, 64.0f + 10, SCREEN_WIDTH - 20, 250)];
        _mainInputView.inputView.delegate = self;
    }
    return _mainInputView;
}

- (Textinputbar *)inputBar {
    if (_inputBar == nil) {
        _inputBar = [[Textinputbar alloc] initWithFrame:CGRectMake(10, self.countLabel.bottom, SCREEN_WIDTH - 20, 50)];
    }
    return _inputBar;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.mainInputView.bottom, SCREEN_WIDTH - 20, 44)];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.text = @"0/160字";
        _countLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _countLabel;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.inputBar.bottom + 20, SCREEN_WIDTH - 20, 40)];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage imageNamed:@"commit_bg"] forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commtiAdvice) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainInputView];
    [self.view addSubview:self.countLabel];
    [self.view addSubview:self.inputBar];
    [self.view addSubview:self.commitButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
}

- (void)commtiAdvice {
    
    if (self.mainInputView.inputView.text.length < 12) {
        [self showTip:@"建议不要少于12个字"];
        return;
    }

    [self showLoading];

    [MCFNetworkManager feedBack:self.mainInputView.inputView.text
                        contact:self.inputBar.inputField.text
                        success:^(NSString *tip) {
                            [self hideLoading];
                            [self showTip:tip];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > 160) {
        [self showTip:@"输入内容限制在160字"];
        return NO;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld/160字", toBeString.length];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
