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
@interface RootTabBarController ()

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
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)installControllers {
    BaseViewController *firstVc = [[BaseViewController alloc] init];
    MCFNavigationController *firstNaviVC = [[MCFNavigationController alloc] initWithRootViewController:firstVc];
    
    BaseViewController *videoVC = [[BaseViewController alloc] init];
    MCFNavigationController *videoNaviVC = [[MCFNavigationController alloc] initWithRootViewController:videoVC];
    
    BaseViewController *serviceVC = [[BaseViewController alloc] init];
    MCFNavigationController *serviceNavi = [[MCFNavigationController alloc] initWithRootViewController:serviceVC];
    
    BaseViewController *lifeVC = [[BaseViewController alloc] init];
    MCFNavigationController *lifeNaviVC = [[MCFNavigationController alloc] initWithRootViewController:lifeVC];
    
    BaseViewController *mineVC = [[BaseViewController alloc] init];
    MCFNavigationController *mineNaviVC = [[MCFNavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[firstNaviVC, videoNaviVC, serviceNavi, lifeNaviVC, mineNaviVC];
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
