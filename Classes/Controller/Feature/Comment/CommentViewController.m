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

@interface CommentViewController ()<CommitCommentDelegate>

@property (nonatomic, strong) CommentBarView *commentBar;
@property (nonatomic, strong) UIButton *colseButton;
@property (nonatomic, strong) NSDictionary *infoDict;
@end

@implementation CommentViewController

- (CommentBarView *)commentBar {
    if (_commentBar == nil) {
        _commentBar = [[CommentBarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100.0f, self.view.width, 100)];
        _commentBar.delegate = self;
    }
    return _commentBar;
}

- (UIButton *)colseButton {
    if (_colseButton == nil) {
        _colseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 64.0f, 20.0f, 54.0f, 54.0f)];
        [_colseButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_colseButton addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colseButton;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    self.infoDict = dict;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.commentBar];
    [self.view addSubview:self.colseButton];
    [self addObserver];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.commentBar.inputView becomeFirstResponder];
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
            [self dismissViewControllerAnimated:NO completion:NULL];
        });
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showTip:@"网络错误"];
    }];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    [self liftCommentBar:height];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    CGFloat height = self.view.height - self.commentBar.bottom;
    [self liftCommentBar:-height];
}

- (void)liftCommentBar:(CGFloat)height {
    
    CGRect frame = self.commentBar.frame;
    frame.origin.y -= height;
    
    if(height>0) {
    
        if(frame.origin.y < 200) return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.commentBar.frame = frame;
    }];
}

- (void)closeController {
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
