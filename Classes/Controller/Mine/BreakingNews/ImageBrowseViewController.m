//
//  ImageBrowseViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/14.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ImageBrowseViewController.h"
#import <YYKit.h>

@interface ImageBrowseViewController ()

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ImageBrowseViewController

- (UIImageView *)contentImageView {
    if (_contentImageView == nil) {
        _contentImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 40.0f, 40.0f)];
        [_backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(didSelectbackButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl {
    self = [super init];
    self.url = imageUrl;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.contentImageView];
    [self.view addSubview:self.backButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.url.length > 0) {
        [self.contentImageView setImageWithURL:[NSURL URLWithString:self.url]
                                   placeholder:nil
                                       options:YYWebImageOptionProgressive
                                    completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                        
                                    }];
    }
}

- (void)didSelectbackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
