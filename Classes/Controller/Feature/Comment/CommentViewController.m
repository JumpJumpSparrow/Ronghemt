//
//  CommentViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/16.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "CommentViewController.h"
#import "MCFNetworkManager+User.h"
#import <YYKit.h>

@protocol CommitCommentDelegate <NSObject>

- (void)publishComment:(NSString *)content;
@end

@interface CommentBarView : UIView<YYTextViewDelegate>

@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, weak) id<CommitCommentDelegate> delegate;
@end

@implementation CommentBarView

- (YYTextView *)inputView {
    if (_inputView == nil) {
        _inputView = [[YYTextView alloc] init];
        _inputView.font = [UIFont systemFontOfSize:13.0f];
        _inputView.textColor = [UIColor blackColor];
        _inputView.delegate = self;
        _inputView.backgroundColor = APPGRAY;
    }
    return _inputView;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        _commitButton = [[UIButton alloc] init];
        [_commitButton setTitle:@"发表" forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(didSelectCommitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.inputView];
    [self addSubview:self.commitButton];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = SCREEN_WIDTH/8.0f;
    self.inputView.frame = CGRectMake(0, 0, width*7 - 20.0f, self.height - 20.0f);
    self.inputView.center = CGPointMake(width * 3.5, self.height/2.0f);
    self.commitButton.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    self.commitButton.center = CGPointMake(width * 7.5 - 10, self.height/2.0f);
}

- (void)didSelectCommitButton {
    if ([self.delegate respondsToSelector:@selector(publishComment:)]) {
        
        [self.delegate publishComment:self.inputView.text];
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString *totalStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (totalStr.length > 160) {
        return NO;
    }
    return YES;
}

@end

@interface CommentViewController ()<YYTextViewDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) NSDictionary *infoDict;
@end

@implementation CommentViewController

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.baseView.bottom, SCREEN_WIDTH - 20, 44)];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.text = @"0/160字";
        _countLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _countLabel;
}

- (YYTextView *)inputView {
    if (_inputView == nil) {
        _inputView = [[YYTextView alloc] initWithFrame:CGRectMake(self.baseView.left + 10.0f, self.baseView.top + 10.0f, self.baseView.width - 20, self.baseView.height - 20)];
        _inputView.placeholderText = @"请输入你想说的话";
        _inputView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _inputView.textAlignment = NSTextAlignmentLeft;
        _inputView.delegate = self;
        _inputView.font = [UIFont systemFontOfSize:15.0f];
    }
    return _inputView;
}

- (UIView *)baseView {
    if (_baseView == nil) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(10, 74.0f, SCREEN_WIDTH - 20, 200)];
        _baseView.layer.cornerRadius = 10.0f;
        _baseView.backgroundColor = APPGRAY;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.countLabel.bottom + 20, SCREEN_WIDTH - 20, 40)];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage imageNamed:@"commit_bg"] forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commitComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    self.infoDict = dict;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.countLabel];
    [self.view addSubview:self.commitButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.inputView becomeFirstResponder];
}

- (void)commitComment {
    [self publishComment:self.inputView.text];
}

- (void)publishComment:(NSString *)content {
    if(content.length == 0) {
        [self showTip:@"请输入您的评论"];
        return;
    }
    [self showLoading];
    [MCFNetworkManager commitComment:content dict:self.infoDict success:^(NSString *tip) {
        [self hideLoading];
        [self showTip:@"评论成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showTip:@"网络错误"];
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
