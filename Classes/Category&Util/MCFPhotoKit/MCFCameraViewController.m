//
//  MCFCameraViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/1.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFCameraViewController.h"
#import <FastttCamera.h>

@interface MCFCameraViewController ()<FastttCameraDelegate>

@property (nonatomic, strong) FastttCamera *fastCamera;
@property (nonatomic, strong) UIButton *triggerButton;
@property (nonatomic, strong) UIButton *torchButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *previewImageView;
@end

@implementation MCFCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;
    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = self.view.frame;
    
    self.triggerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0f - 40.0f, self.view.frame.size.height - 100.0f, 80.0f, 80.0f)];
    [self.triggerButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    self.triggerButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.triggerButton];
    
    self.torchButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, self.view.frame.size.height - 40.0f - 20.0f, 40.0f, 40.0f)];
    [self.torchButton addTarget:self action:@selector(selectFleshMode:) forControlEvents:UIControlEventTouchUpInside];
    self.torchButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.torchButton];
    
    self.switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40.0f - 20.0f, self.view.frame.size.height - 40.0f - 20.0f, 40.0f, 40.0f)];
    [self.switchButton addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    self.switchButton.backgroundColor  = [UIColor cyanColor];
    [self.view addSubview:self.switchButton];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 44.0f, 44.0f)];
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    [self.cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(didSelectCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImage:(FastttCapturedImage *)capturedImage {
    
    UIView *flashView = [[UIView alloc] initWithFrame:self.fastCamera.view.frame];
    flashView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f];
    flashView.alpha = 0.f;
    [self.view addSubview:flashView];
    
    [UIView animateWithDuration:0.15f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         flashView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         
                         self.previewImageView = [[UIImageView alloc] initWithFrame:flashView.frame];
                         self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
                         self.previewImageView.image = capturedImage.rotatedPreviewImage;
                         [self.view insertSubview:self.previewImageView belowSubview:flashView];
                         
                         [UIView animateWithDuration:0.15f
                                               delay:0.05f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              flashView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [flashView removeFromSuperview];
                                          }];
                     }];

}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishScalingCapturedImage:(FastttCapturedImage *)capturedImage {

}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImageData:(NSData *)rawJPEGData {

}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage {

}

- (void)takePhoto {
    [self.fastCamera takePicture];
}

- (void)selectFleshMode:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([FastttCamera isFlashAvailableForCameraDevice:self.fastCamera.cameraDevice]) {
        [self.fastCamera setCameraFlashMode:FastttCameraFlashModeAuto];
    }
}

- (void)didSelectCancel {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)switchCamera:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    FastttCameraDevice device = FastttCameraDeviceFront;
    if (sender.selected) {
        device = FastttCameraDeviceRear;
    }
    if ([FastttCamera isCameraDeviceAvailable:device]) {
        
        [self.fastCamera setCameraDevice:device];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end