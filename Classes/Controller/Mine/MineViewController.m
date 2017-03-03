//
//  MineViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MineViewController.h"
#import "IconTitleCell.h"
#import "UserHeader.h"
#import "MCFUserModel.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "CollectionViewController.h"
#import "FeedbackViewController.h"
#import "RegistViewController.h"
#import "LogInViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, AvatarTapDelegate>

@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, strong) MCFUserModel *user;
@property (nonatomic, strong) NSArray *optionArray;
@end

@implementation MineViewController

- (UITableView *)listTable {
    if (_listTable == nil) {
        _listTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.scrollEnabled = NO;
        [_listTable registerClass:[IconTitleCell class] forCellReuseIdentifier:@"IconTitleCell"];
        [_listTable registerClass:[UserHeader class] forHeaderFooterViewReuseIdentifier:@"UserHeader"];
    }
    return _listTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[MCFUserModel alloc] init];
    self.user.username = @"Jonh";
    self.user.avatar = @"https://a-ssl.duitang.com/uploads/item/201702/16/20170216103533_aQmuJ.jpeg";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Mine" ofType:@"plist"];
    self.optionArray = [NSArray arrayWithContentsOfFile:path];
    self.automaticallyAdjustsScrollViewInsets  =NO;
    [self.view addSubview:self.listTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkLoginStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - avatarDelegate
- (void)didTapAvatar:(MCFUserModel *)user {
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUser:user];
    profileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileVC animated:YES];
}
//-------------取反
- (void)checkLoginStatus {
    if([MCFTools isLogined]){
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:NO];
        return;
    }
}

#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CollectionViewController *collectionVc = [[CollectionViewController alloc] init];
        collectionVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collectionVc animated:YES];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            FeedbackViewController *feedVc = [[FeedbackViewController alloc] init];
            feedVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedVc animated:YES];
        } else if (indexPath.row == 1) {
            SettingViewController *settingVc = [[SettingViewController alloc] init];
            settingVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVc animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.optionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subArray = [self.optionArray objectAtIndex:section];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IconTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconTitleCell" forIndexPath:indexPath];
    NSArray *subArray = [self.optionArray objectAtIndex:indexPath.section];
    NSDictionary *dataDict = [subArray objectAtIndex:indexPath.row];
    [cell bindWithModel:dataDict];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header;
    if (section == 0){
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UserHeader"];
        UserHeader *userHeader = (UserHeader *)header;
        userHeader.delegate = self;
        [userHeader bindWithModel:self.user];
    } else {
        header = [[UIView alloc] init];
        header.backgroundColor = [UIColor clearColor];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 1;
    if (section == 0) {
        height = 200.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
