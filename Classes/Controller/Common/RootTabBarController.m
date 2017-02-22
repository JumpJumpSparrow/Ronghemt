//
//  RootTabBarController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "RootTabBarController.h"
#import "BaseViewController.h"
#import "MCFNavigationController.h"
#import "MCFTabBar.h"
#import "MCFNetworkManager+NaVi.h"
#import "MCFTools.h"
#import "MCFHomeViewController.h"
#import "VideoViewController.h"
#import "ServiceViewController.h"
#import "LifeViewController.h"
#import "MineViewController.h"

@interface RootTabBarController ()

@property (nonatomic, strong) NSArray *naviItems;
@property (nonatomic, strong) NSArray *childControllers;
@end

@implementation RootTabBarController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self installControllers];
        [self customTabBar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MCFTabBar *tabBar = [[MCFTabBar alloc] init];
    tabBar.translucent = NO;
    [self setValue:tabBar forKey:@"tabBar"];
    
    [self loadNavi];
}

- (void)loadNavi {
    [MCFNetworkManager requestNaviTypeSuccess:^(NSArray *channels) {
        
        self.naviItems = channels;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
        
    } failure:^(NSError *error) {
        [MCFTools showAlert:@"网络错误，请退出重试" to:self completion:NULL];
    }];
}

- (void)reloadData {
    MCFHomeViewController *firstVc = [self.childControllers objectAtIndex:0];
    [firstVc loadChannels:self.naviItems[0]];
    
    VideoViewController *videoVC = [self.childControllers objectAtIndex:1];
    [videoVC loadChannels:self.naviItems[1]];
    
    ServiceViewController *serviceVC = [self.childControllers objectAtIndex:2];
    MCFNaviModel *naviModel = self.naviItems[2];
    serviceVC.url = naviModel.navigationUrl;
    
    LifeViewController *lifeVc = [self.childControllers objectAtIndex:3];
    [lifeVc loadChannels:self.naviItems[3]];
}

- (void)installControllers {
    MCFHomeViewController *homeVc = [[MCFHomeViewController alloc] init];
    MCFNavigationController *homeNaviVC = [[MCFNavigationController alloc] initWithRootViewController:homeVc];
    
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    MCFNavigationController *videoNaviVC = [[MCFNavigationController alloc] initWithRootViewController:videoVC];
    
    ServiceViewController *serviceVC = [[ServiceViewController alloc] init];
    MCFNavigationController *serviceNavi = [[MCFNavigationController alloc] initWithRootViewController:serviceVC];
    
    LifeViewController *lifeVC = [[LifeViewController alloc] init];
    MCFNavigationController *lifeNaviVC = [[MCFNavigationController alloc] initWithRootViewController:lifeVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    MCFNavigationController *mineNaviVC = [[MCFNavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[homeNaviVC, videoNaviVC, serviceNavi, lifeNaviVC, mineNaviVC];
    self.childControllers = @[homeVc, videoVC, serviceVC, lifeVC, mineVC];
}

- (void)customTabBar {
    
    NSArray *imgArray = @[@"infor", @"video", @"service", @"life", @"mine"];
    NSArray *titleArray = @[@"首页", @"视频", @" ", @"生活", @"我的"];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:AppColorSelected],NSForegroundColorAttributeName,nil]forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:AppColorNormal],NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    for(int i = 0; i < self.tabBar.items.count; i++ ) {
        
        UITabBarItem* tabBarItem = self.tabBar.items[i];
        
        tabBarItem.title = titleArray[i];
        
        NSString *normalImagename = [NSString stringWithFormat:@"%@_normal", [imgArray objectAtIndex:i]];
        NSString *selectedImageName = [NSString stringWithFormat:@"%@_selected", [imgArray objectAtIndex:i]];
        UIImage* unselectedImage = [UIImage imageNamed:normalImagename];
        UIImage* selectedImage = [UIImage imageNamed:selectedImageName];
        
        if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        tabBarItem.image = unselectedImage;
        tabBarItem.selectedImage = selectedImage;
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
