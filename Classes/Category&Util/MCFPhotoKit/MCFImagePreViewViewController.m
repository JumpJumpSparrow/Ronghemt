//
//  MCFImagePreViewViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/2.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFImagePreViewViewController.h"
#import "MCFImageCropView.h"
#import <YYKit.h>
#import <RSKImageCropper/RSKImageCropper.h>
#import "MCFNetworkManager+User.h"
#import "MCFImageCropViewController.h"

@interface MCFImagePreViewViewController ()

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation MCFImagePreViewViewController

- (UIImageView *)contentImageView {
    if (_contentImageView == nil) {
        _contentImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:AppColorSelected] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(didSelectCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


- (UIButton *)nextStepButton {
    if (!_nextStepButton) {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepButton setTitle:@"选取" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor colorWithHexString:AppColorSelected] forState:UIControlStateNormal];
        [_nextStepButton sizeToFit];
        [_nextStepButton addTarget:self action:@selector(didSelectDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    self.originImage = image;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    [self.view addSubview:self.contentImageView];
    self.contentImageView.image = self.originImage;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextStepButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didSelectCancel {
    [self.navigationController popViewControllerAnimated:YES];// to do
    
}

- (void)didSelectDone {
    
    if (self.cropImage) {
        MCFImageCropViewController *imageCropVC = [[MCFImageCropViewController alloc] initWithImage:self.originImage];
        imageCropVC.didCropImage = self.didSelectImage;
        [self.navigationController pushViewController:imageCropVC animated:YES];
    } else {
        if (self.didSelectImage) {
            self.didSelectImage(self.originImage);
        }
        UIViewController *vc = [self.navigationController.childViewControllers objectAtIndex:1];
        [self.navigationController popToViewController:vc animated:YES];
    }
    
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
