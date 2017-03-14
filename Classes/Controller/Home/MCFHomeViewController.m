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
#import <objc/runtime.h>

@interface MCFHomeViewController ()<WMPageControllerDelegate, WMPageControllerDataSource>

@property (nonatomic, strong) MCFNaviModel *naviModel;
@property (nonatomic, strong) NSArray *channelsArray;// 二级导航各频道
@property (nonatomic, strong) WMPageController *pageManagerController;
@property (nonatomic, strong) UIView *titleItem;
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
    if (appType == AppEditionWF) {
        [self resetNaviBar];
    } else {
        self.title = @"城市无线";
    }
    [self addChildViewController:self.pageManagerController];
    [self.view addSubview:self.pageManagerController.view];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.titleItem) {
        self.titleItem.hidden = YES;
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.titleItem) {
        self.titleItem.hidden = NO;
    }
    [super viewDidAppear:animated];
    self.pageManagerController.selectIndex = (int)self.selectedIndex ;
}

- (void)resetNaviBar {
    CGRect frame = self.navigationController.navigationBar.bounds;
    frame.size.height += 5;
    UIView *baseView = [[UIView alloc] initWithFrame:frame];
    baseView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:20.0f];
    titleLabel.textColor = [UIColor colorWithHexString:AppColorSelected];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"今日潍坊";
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(titleLabel.width/ 2 + 20.0f, baseView.height/2.0f);
    [baseView addSubview:titleLabel];
    
    UILabel *SubTitleLabel = [[UILabel alloc] init];
    SubTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    SubTitleLabel.textColor = [UIColor blackColor];
    SubTitleLabel.textAlignment = NSTextAlignmentRight;
    SubTitleLabel.text = @"潍坊报业集团主办";
    [SubTitleLabel sizeToFit];
    SubTitleLabel.center = CGPointMake(baseView.width - SubTitleLabel.width/2.0f - 20.0f, baseView.height - SubTitleLabel.height/2.0f - 12);
    [baseView addSubview:SubTitleLabel];
    self.titleItem = baseView;
    [self.navigationController.navigationBar addSubview:baseView];
}

//重置
//- (NSInteger)selectedIndex {
//    NSInteger index = _selectedIndex;
//    _selectedIndex = 0;
//    return index;
//}

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
