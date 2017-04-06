//
//  SettingViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "MCFNetworkManager+User.h"
#import <YYKit.h>
#import "MCFCacheUtil.h"
#import <MBProgressHUD.h>
#import "ShareViewController.h"
#import "MCFShareUtil.h"

@interface TitlesButton : UIButton

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *accessoryView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@end

@implementation TitlesButton

- (void)setTitle:(NSString *)title {
    self.nameLabel.text = title;
    _title = title;
    [self setNeedsLayout];
}

- (void)setSubTitle:(NSString *)subTitle {
    self.subTitleLabel.text = subTitle;
    _subTitle = subTitle;
    [self setNeedsLayout];
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor grayColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    [self addSubview:self.subTitleLabel];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel sizeToFit];
    [self.subTitleLabel sizeToFit];
    
    self.nameLabel.center = CGPointMake(self.nameLabel.width/2.0f +  20.0f, self.height/2.0f);
    self.subTitleLabel.center = CGPointMake(self.width - self.subTitleLabel.width/2.0f - 10, self.height/2.0f);
}

@end

@interface SettingViewController ()

@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) TitlesButton *recommandButton;
@property (nonatomic, strong) TitlesButton *cacheButton;
@property (nonatomic, strong) TitlesButton *editionButton;
@end

@implementation SettingViewController

- (TitlesButton *)recommandButton {
    if (_recommandButton == nil) {
        _recommandButton = [[TitlesButton alloc] initWithFrame:CGRectMake(0, 74.0f, SCREEN_WIDTH, 44.0f)];
        _recommandButton.title = @"推荐好友";
        _recommandButton.tag = 0;
        [_recommandButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recommandButton;
}

- (TitlesButton *)cacheButton {
    if (_cacheButton == nil) {
        _cacheButton = [[TitlesButton alloc] initWithFrame:CGRectMake(0, 74.0f, SCREEN_WIDTH, 44.0f)];
        _cacheButton.title = @"清除缓存";
        _cacheButton.subTitle = @"0.00M";
        _cacheButton.tag = 1;
        [_cacheButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cacheButton;
}

- (TitlesButton *)editionButton {
    if (_editionButton == nil) {
        _editionButton = [[TitlesButton alloc] initWithFrame:CGRectMake(0, self.cacheButton.bottom + 10, SCREEN_WIDTH, 44.0f)];
        _editionButton.title = @"版本号";
        _editionButton.subTitle = @"V1.01";
        _editionButton.tag = 3;
        [_editionButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editionButton;
}

- (UIButton *)logoutButton {
    if (_logoutButton == nil) {
        _logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.height - 44.0f - 10.0f, self.view.width - 20, 44.0f)];
        [_logoutButton setTitle:@"注销当前帐号" forState:UIControlStateNormal];
        [_logoutButton setBackgroundImage:[UIImage imageNamed:@"commit_bg"] forState:UIControlStateNormal];
        [_logoutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

//推荐好友
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APPGRAY;
    self.title = @"设置";
    [self.view addSubview:self.logoutButton];
    //[self.view addSubview:self.recommandButton];
    [self.view addSubview:self.cacheButton];
    [self.view addSubview:self.editionButton];
    self.logoutButton.hidden = ![MCFTools isLogined];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.cacheButton.subTitle = [self calculateCacheSize];
}

- (void)didSelectButton:(TitlesButton *)sender {
    if (sender.tag == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"正在清理内存";
        [MCFCacheUtil cleanCacheInPath:kPathLibraryCacheDirectory];
        [MCFCacheUtil cleanCacheInTemporaryDirectory];
        hud.label.text = [NSString stringWithFormat:@"已清理%@内存空间", self.cacheButton.subTitle];
        self.cacheButton.subTitle = @"0.0MB";
        [hud hideAnimated:YES afterDelay:2.0f];
    } else if (sender.tag == 0) {
        [MCFShareUtil showShareMenuToShareUrl:@"www.baidu.com"];
    }
}

- (NSString *)calculateCacheSize {
    double sizeInCache = [MCFCacheUtil cacheSizeInPath:kPathLibraryCacheDirectory];
    double sizeInTemp = [MCFCacheUtil cacheSizeInTemporaryDirectory];
    double size = sizeInCache + sizeInTemp;
    NSString *sizeString = @"";
    if (size < 1) {
        sizeString = [NSString stringWithFormat:@"%.2fKB", size*1000];
    } else {
        sizeString = [NSString stringWithFormat:@"%.2fMB", size];
    }
    return sizeString;
}

- (void)logOut {
    
    if(![MCFTools isLogined]) return;
    [self showLoading];
    [MCFNetworkManager logOutUserSuccess:^(NSString *tip) {
        [self hideLoading];
        [self showTip:tip];
        [MCFTools clearLoginUser];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //[delegate.rootVc switchToIndex:0 subIndex:0];
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
