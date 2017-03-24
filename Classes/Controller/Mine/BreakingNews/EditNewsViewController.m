//
//  EditNewsViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/14.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "EditNewsViewController.h"
#import <YYKit.h>
#import "MCFNetworkManager+User.h"

@interface EditNewsViewController ()<YYTextViewDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITableView *photoListView;
@end

@implementation EditNewsViewController

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
        _inputView.placeholderText = @"请输入你的爆料...";
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"编辑内容";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.countLabel];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishButton addTarget:self action:@selector(didSelectPublish) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setTitle:@"爆料" forState:UIControlStateNormal];
    [publishButton sizeToFit];
    [publishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:publishButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
}

- (void)didSelectPublish {
    
    
    
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

@end
