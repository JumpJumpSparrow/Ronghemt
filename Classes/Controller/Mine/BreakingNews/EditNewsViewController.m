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
#import "ImageBrowseViewController.h"
#import "ImageGridView.h"
#import "MCFPhotoKit.h"

NSInteger imageCountLimit = 3;

@interface EditNewsViewController ()<YYTextViewDelegate, ImageGridDelegate, CameraDataDelegate, MCFPhotoDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITableView *photoListView;
@property (nonatomic, strong) ImageGridView *gridView;
@property (nonatomic, strong) NSMutableArray *selectedImages;
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

- (ImageGridView *)gridView {
    if (_gridView == nil) {
        _gridView = [[ImageGridView alloc] initWithFrame:CGRectMake(0, self.countLabel.bottom, SCREEN_WIDTH, 0)];
        _gridView.delegate = self;
    }
    return _gridView;
}

- (NSMutableArray *)selectedImages {
    if (_selectedImages == nil) {
        _selectedImages = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"编辑内容";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.countLabel];
    [self.view addSubview:self.gridView];
    self.gridView.limitCount = imageCountLimit;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didSelectPublish {
    [self.view endEditing:YES];
    if (self.inputView.text.length == 0) {
        [self showTip:@"请输入爆料内容"];
        return;
    }
    
    [self showLoading];
    [MCFNetworkManager uploadImages:self.selectedImages
                         completion:^(NSArray<NSString *> *urls) {
                             [self hideLoading];
                             
                             NSString *finalStr;
                             if (urls.count == 0) {
                                 finalStr = @"null";
                             } else {
                                 NSMutableString *file = [[NSMutableString alloc] init];
                                 for (NSString *url in urls) {
                                     [file appendString:url];
                                     [file appendString:@","];
                                 }
                                 finalStr = [file substringToIndex:file.length - 1];
                             }
                             
                             NSInteger type = urls.count == 0 ? 0 : 1;
                             NSDictionary *dict = @{
                                                    @"session" : [MCFTools getLoginUser].session,
                                                    @"content" : self.inputView.text,
                                                    @"title" : @"breakNews",
                                                    @"type" : @(type),
                                                    @"file" : finalStr,
                                                    @"siteCode" : [MCFConfigure cfg].siteCode
                                                    };
                             [self publishBreakNews:dict];
    }];
}

- (void)publishBreakNews:(NSDictionary *)dict {
    [self showLoading];
    [MCFNetworkManager publishBreakNews:dict success:^(NSString *tip) {
        [self hideLoading];
        [self showTip:tip];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            if (self.refreshData) {
                self.refreshData();
            }
        });
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showTip:@"网络错误"];
    }];
}

#pragma mark - imageGrideDelegate
- (void)imageGrideDidSelectAddImageButton {
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择照片源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self requestCameraAuthority];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestPhotoAuthority];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:NULL];

}

- (void)deletSelectedItemAtIndex:(NSInteger)index {
    [self.selectedImages removeObjectAtIndex:index];
    [self.gridView loadImages:self.selectedImages];
}

- (void)displySelectedImage:(UIImage *)image {
    ImageBrowseViewController *imageVc = [[ImageBrowseViewController alloc] initWithImage:image];
    [self.navigationController pushViewController:imageVc animated:YES];
}

- (void)cameraDidSelectImage:(UIImage *)image {
    
    if ((self.selectedImages.count + 1) > imageCountLimit) {
        [self showTip:[NSString stringWithFormat:@"最多选择%ld张",(long)imageCountLimit]];
        return;
    }
    [self.selectedImages addObject:image];
    [self.gridView loadImages:self.selectedImages];
}

- (void)MCFPhotoLibraryDidSelectImages:(NSArray *)images {
    
    if ((self.selectedImages.count + images.count) > imageCountLimit) {
        [self showTip:[NSString stringWithFormat:@"最多选择%ld张",(long)imageCountLimit]];
        return;
    }

    
    for (PHAsset *asset in images) {
        [MCFPhotoLibrary requestImageForAsset:asset completion:^(UIImage *image, NSDictionary *infor) {
            [self.selectedImages addObject:image];
            [self.gridView loadImages:self.selectedImages];
        }];
    }
}

- (void)requestCameraAuthority {
    [MCFPhotoLibrary checkCameraAuthorization:self completion:^(AVAuthorizationStatus status) {
        if (status == AVAuthorizationStatusAuthorized) {
            MCFCameraViewController *cameraVC = [[MCFCameraViewController alloc] init];
            cameraVC.delegate = self;
            [self.navigationController pushViewController:cameraVC animated:YES];
        }
    }];
}

- (void)requestPhotoAuthority {
    [MCFPhotoLibrary checkAuthorization:self completion:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            MCFPhotoLibraryViewController *photoVC = [[MCFPhotoLibraryViewController alloc] init];
            photoVC.delegate = self;
            photoVC.limitCount = imageCountLimit;
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > 160) {
        [self showTip:@"输入内容限制在160字"];
        return NO;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld/160字", (unsigned long)toBeString.length];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
