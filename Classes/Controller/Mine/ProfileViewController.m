//
//  ProfileViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ProfileViewController.h"
#import "MCFUserModel.h"

@interface ProfileViewController ()

@property (nonatomic, strong) MCFUserModel *user;
@end

@implementation ProfileViewController

- (instancetype)initWithUser:(MCFUserModel *)user {
    self = [super init];
    self.user = user;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改资料";
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
