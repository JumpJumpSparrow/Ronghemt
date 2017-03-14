//
//  BreakingNewsViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/13.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BreakingNewsViewController.h"
#import "BreakingNewsItemViewController.h"
#import <WMPageController.h>
#import <YYKit.h>

@interface BreakingNewsViewController ()<WMPageControllerDelegate, WMPageControllerDataSource>

@property (nonatomic, strong) WMPageController *pageManagerController;
@end

@implementation BreakingNewsViewController


- (WMPageController *)pageManagerController {
    if (_pageManagerController == nil) {
        _pageManagerController = [[WMPageController alloc] init];
        _pageManagerController.menuViewStyle = WMMenuViewStyleLine;
        _pageManagerController.menuView.lineColor = [UIColor colorWithHexString:AppColorSelected];
        _pageManagerController.menuHeight = 34.0f;
        _pageManagerController.menuItemWidth = 100.0f;
        _pageManagerController.titleColorSelected = [UIColor colorWithHexString:AppColorSelected];
        _pageManagerController.titleColorNormal = [UIColor colorWithHexString:AppColorNormal];
        _pageManagerController.titleSizeNormal = 14.f;
        _pageManagerController.titleSizeSelected = 18.f;
        _pageManagerController.menuBGColor = [UIColor whiteColor];
        _pageManagerController.bounces = YES;
        _pageManagerController.delegate = self;
        _pageManagerController.dataSource = self;
        _pageManagerController.hidesBottomBarWhenPushed = YES;
    }
    return _pageManagerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爆料";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.pageManagerController];
    [self.view addSubview:self.pageManagerController.view];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    BreakingNewsItemViewController *itemVc = [[BreakingNewsItemViewController alloc] init];
    itemVc.isPrivate = index == 1;
    return itemVc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"大家的爆料", @"我的爆料"];
    return titles[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
