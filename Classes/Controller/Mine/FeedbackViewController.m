//
//  FeedbackViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "FeedbackViewController.h"
#import <YYKit.h>

@interface TextInputView : UIView<YYTextViewDelegate>

@property (nonatomic, strong) YYTextView *inputView;
@end

@implementation TextInputView

- (YYTextView *)inputView {
    if (_inputView == nil) {
        _inputView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 10, self.width - 20, self.height - 20)];
        _inputView.placeholderText = @"请输入您遇到的问题...";
        _inputView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _inputView.textAlignment = NSTextAlignmentLeft;
        _inputView.delegate = self;
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

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
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


@interface FeedbackViewController ()

@property (nonatomic, strong) TextInputView *mainInputView;
@property (nonatomic, strong) Textinputbar *inputBar;
@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation FeedbackViewController

- (TextInputView *)mainInputView {
    if (_mainInputView == nil) {
        _mainInputView = [[TextInputView alloc] initWithFrame:CGRectMake(10, 64.0f + 10, SCREEN_WIDTH - 20, 250)];
    }
    return _mainInputView;
}

- (Textinputbar *)inputBar {
    if (_inputBar == nil) {
        _inputBar = [[Textinputbar alloc] initWithFrame:CGRectMake(10, self.mainInputView.bottom + 20, SCREEN_WIDTH - 20, 50)];
    }
    return _inputBar;
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
    [self.view addSubview:self.inputBar];
    [self.view addSubview:self.commitButton];
}

- (void)commtiAdvice {

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
