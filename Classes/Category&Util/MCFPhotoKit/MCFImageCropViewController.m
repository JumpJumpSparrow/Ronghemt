//
//  MCFImageCropViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/22.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFImageCropViewController.h"
#import <RSKImageCropper.h>

@interface MCFImageCropViewController ()<RSKImageCropViewControllerDelegate>

@property (nonatomic, strong) UIImage *targetImage;
@end

@implementation MCFImageCropViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    self.targetImage = image;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:self.targetImage];
    imageCropVC.delegate = self;
    [self addChildViewController:imageCropVC];
    [self.view addSubview:imageCropVC.view];
}

//取消
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    if (self.didCropImage) {
        self.didCropImage(croppedImage);
    }
    UIViewController *vc = [self.navigationController.childViewControllers objectAtIndex:1];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
