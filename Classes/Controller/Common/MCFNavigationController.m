//
//  MCFNavigationController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFNavigationController.h"

@interface MCFNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *currentViewController;
@end

@implementation MCFNavigationController


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    if ([self.viewControllers count] > 1) {
       
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed:@"back"]
                                                                                                   imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:self
                                                                                          action:@selector(popViewControllerAnimated:)];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1)
        self.currentViewController = Nil;
    else
        self.currentViewController = viewController;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentViewController == self.topViewController);
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
