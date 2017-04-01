//
//  BreakingNewsItemViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/13.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BreakingNewsItemViewController.h"
#import "MCFNetworkManager+User.h"
#import "ImageBrowseViewController.h"
#import "EditNewsViewController.h"
#import "LogInViewController.h"
#import <YYKit.h>
#import "HeaderTitleCell.h"
#import "TextContentCell.h"
#import "ImageGridCell.h"
#import "TimeLabelCell.h"
#import "BreakNews.h"
#import <MJRefresh.h>

@interface BreakingNewsItemViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ImageDetailDelegat>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) UIImageView *emptyImageView;
@end

@implementation BreakingNewsItemViewController

- (UIButton *)publishButton {
    if (_publishButton == nil) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80.0f, 80.0f)];
        _publishButton.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - 40.0f);
        [_publishButton setImage:[UIImage imageNamed:@"addphoto"] forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(didSelectPublishButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

- (UICollectionView *)contentCollectionView {
    if (_contentCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 0);
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = APPGRAY;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        [_contentCollectionView registerClass:[HeaderTitleCell class] forCellWithReuseIdentifier:@"HeaderTitleCell"];
        [_contentCollectionView registerClass:[TextContentCell class] forCellWithReuseIdentifier:@"TextContentCell"];
        [_contentCollectionView registerClass:[ImageGridCell class] forCellWithReuseIdentifier:@"ImageGridCell"];
        [_contentCollectionView registerClass:[TimeLabelCell class] forCellWithReuseIdentifier:@"TimeLabelCell"];
    }
    return _contentCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self installParts];
}

- (void)installParts {
    [self.view addSubview:self.contentCollectionView];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.contentCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:1];
    }];
    
    self.contentCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self requestData:self.page];
    }];
    [self.contentCollectionView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.contentCollectionView addObserver:self
                                 forKeyPath:@"contentOffset"
                                    options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                    context:nil];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.publishButton];
    [keyWindow bringSubviewToFront:self.publishButton];
    
    if (self.isPrivate && ![MCFTools isLogined]) {
        [self showEmptyView:YES];
        self.contentCollectionView.scrollEnabled = NO;
        [self .dataArray removeAllObjects];
        [self.contentCollectionView reloadData];
        [self endRefreshing];
    } else {
        self.contentCollectionView.scrollEnabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.contentCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    [self.publishButton removeFromSuperview];
}

- (void)requestData:(NSInteger)page {
    
    if (self.isPrivate && ![MCFTools isLogined]) {
        [self endRefreshing];
        [self showTip:@"您尚未登录"];
        return;
    }
    [self showLoading];
    
    [MCFNetworkManager requestBreakNewsPrivate:self.isPrivate
                                          page:page
                                       success:^(NSInteger page, NSInteger total, NSArray *itemList) {
                                           [self hideLoading];
                                           [self endRefreshing];
                                           if (page == 1) {
                                               [self.dataArray removeAllObjects];
                                               [self showEmptyView:(itemList.count == 0)];
                                           }
                                           if (itemList.count == 0) {
                                               [self showTip:@"无更多数据"];
                                               return;
                                           }
                                           self.page = page;
                                           [self.dataArray addObjectsFromArray:itemList];
                                           [self.contentCollectionView reloadData];
    } failure:^(NSError *error) {
        [self hideLoading];
        [self endRefreshing];
    }];
    
}

- (void)showEmptyView:(BOOL)isEmpty {
    if (self.emptyImageView) {
        [self.emptyImageView removeFromSuperview];
    }
    UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baoliao_null"]];
    [emptyImageView sizeToFit];
    emptyImageView.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0);
    [self.view addSubview:emptyImageView];
    self.emptyImageView = emptyImageView;
    emptyImageView.hidden = !isEmpty;
}

- (void)endRefreshing {
    [self.contentCollectionView.mj_header endRefreshing];
    [self.contentCollectionView.mj_footer endRefreshing];
}

- (void)didSelectPublishButton {
    
    if ([MCFTools isLogined]) {
        
        EditNewsViewController *newsVC = [[EditNewsViewController alloc] init];
        newsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsVC animated:YES];
    } else {
        LogInViewController *logVC = [[LogInViewController alloc] init];
        logVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:logVC animated:YES];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGPoint newPoint = [[change objectForKey:@"new"] CGPointValue];
    
    CGRect frame = self.publishButton.frame;
    if (newPoint.y > 100) { // up
        if (frame.origin.y < SCREEN_HEIGHT) {
            frame.origin.y = SCREEN_HEIGHT + 10.0f;
            [UIView animateWithDuration:0.5 animations:^{
                self.publishButton.frame = frame;
            }];
        }
    } else {
        if (frame.origin.y > SCREEN_HEIGHT) {
            frame.origin.y = SCREEN_HEIGHT - 80.0f;
            [UIView animateWithDuration:0.5 animations:^{
                self.publishButton.frame = frame;
            }];
        }
    }
}

#pragma mark - delegate
- (void)didSelectNews:(BreakNews *)news index:(NSInteger)index {
    
    NSArray *photos = [news.photo1 componentsSeparatedByString:@","];
    if (index >= 0 && index < photos.count) {
        NSString *imageUrl = photos[index];
        ImageBrowseViewController *imageVC = [[ImageBrowseViewController alloc] initWithImageUrl:imageUrl];
        [self.navigationController pushViewController:imageVC animated:YES];
    }
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 2;
    BreakNews *news = self.dataArray[section];
    if (news.content.length > 0) {
        count += 1;
    }
    if (news.photo1.length > 0) {
        count += 1;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = nil;
    
    BreakNews *news = [self.dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.item == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderTitleCell" forIndexPath:indexPath];
    }
    else if (indexPath.item == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextContentCell" forIndexPath:indexPath];
    }
    else if (indexPath.item == 2 && news.photo1.length > 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageGridCell" forIndexPath:indexPath];
        ImageGridCell *imageCell = (ImageGridCell *)cell;
        imageCell.delegate = self;
    }
    else if(indexPath.item == 3 || (indexPath.item == 2 && news.photo1.length == 0)) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeLabelCell" forIndexPath:indexPath];
    }
    
    [cell bindWithModel:news];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    BreakNews *news = [self.dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.item == 0) {
        size = [HeaderTitleCell sizeWithModel:nil];
    }
    else if (indexPath.item == 1) {
        size = [TextContentCell sizeWithModel:news];
    }
    else if (indexPath.item == 2 && news.photo1.length > 0) {
        size = [ImageGridCell sizeWithModel:nil];
    }
    else if(indexPath.item == 3 || (indexPath.item == 2 && news.photo1.length == 0)) {
        size = [TimeLabelCell sizeWithModel:nil];
    }
    return size;
}

- (void)dealloc {
    NSLog(@"memory realeased!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
