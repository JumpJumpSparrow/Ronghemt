//
//  MCFHomeViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFHomeViewController.h"
#import <WMPageController.h>
#import "MCFNaviModel.h"
#import "BaseWebViewController.h"

@interface MCFHomeViewController ()<WMPageControllerDelegate, WMPageControllerDataSource>

@property (nonatomic, strong) MCFNaviModel *naviModel;
@property (nonatomic, strong) NSArray *channelsArray;// 二级导航各频道
@property (nonatomic, strong) WMPageController *pageManagerController;
@end

@implementation MCFHomeViewController

- (WMPageController *)pageManagerController {
    if (_pageManagerController == nil) {
        _pageManagerController = [[WMPageController alloc] init];
        _pageManagerController.menuViewStyle = WMMenuViewStyleLine;
        _pageManagerController.menuView.lineColor = [UIColor colorWithHexString:AppColorSelected];
        _pageManagerController.menuHeight = 34.0f;
        _pageManagerController.menuItemWidth = 50.0f;
        _pageManagerController.titleColorSelected = [UIColor colorWithHexString:AppColorSelected];
        _pageManagerController.titleColorNormal = [UIColor colorWithHexString:AppColorNormal];
        _pageManagerController.titleSizeNormal = 14.f;
        _pageManagerController.titleSizeSelected = 18.f;
        _pageManagerController.menuBGColor = [UIColor whiteColor];
        _pageManagerController.bounces = YES;
        _pageManagerController.delegate = self;
        _pageManagerController.dataSource = self;
    }
    return _pageManagerController;
}

- (instancetype)initWithChannels:(MCFNaviModel *)naviModel {
    self = [super init];
    if (self) {
        self.channelsArray = naviModel.data;
        self.naviModel = naviModel;
    }
    return self;
}

- (void)loadChannels:(MCFNaviModel *)naviModel {
    self.channelsArray = naviModel.data;
    self.naviModel = naviModel;
    [self.pageManagerController reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市无线";
    [self addChildViewController:self.pageManagerController];
    [self.view addSubview:self.pageManagerController.view];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.channelsArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    MCFNaviModel *naviModel = [self.channelsArray objectAtIndex:index];
    BaseWebViewController *webViewController = [[BaseWebViewController alloc] initWithUrl:naviModel.navigationUrl];
    
    return webViewController;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    MCFNaviModel *naviModel = [self.channelsArray objectAtIndex:index];
    return naviModel.navigationName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
