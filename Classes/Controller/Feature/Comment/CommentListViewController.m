//
//  CommentListViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "CommentListViewController.h"
#import "MCFNetworkManager+User.h"
#import "CommentContentCell.h"
#import "CommentHeader.h"
#import <MJRefresh.h>

@interface CommentListViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger globalID;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) NSDictionary *infoDict;
@end

@implementation CommentListViewController

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
        [_contentCollectionView registerClass:[CommentHeader class] forCellWithReuseIdentifier:@"CommentHeader"];
        [_contentCollectionView registerClass:[CommentContentCell class] forCellWithReuseIdentifier:@"CommentContentCell"];
    }
    return _contentCollectionView;
}

- (instancetype)initWithGlobalId:(NSInteger)globalId {
    self = [super init];
    self.globalID = globalId;
    return self;
}

- (instancetype)initWithPageInfo:(NSDictionary *)infoDict {
    self = [super init];
    self.infoDict = infoDict;
    return self;
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
- (void)requestData:(NSInteger)page {
    
    [self showLoading];
    [MCFNetworkManager requestCommentList:self.infoDict
                                     page:page
                                  success:^(NSInteger page, NSArray *commentList) {
                                      [self hideLoading];
                                      [self endRefreshing];
                                      if (page == 1) {
                                          [self.dataArray removeAllObjects];
                                      }
                                      if (commentList.count == 0) {
                                          [self showTip:@"暂无任何评论"];
                                          return;
                                      }
                                      self.page = page;
                                      [self.dataArray addObjectsFromArray:commentList];
                                      [self.contentCollectionView reloadData];
        
    } failure:^(NSError *error) {
        [self hideLoading];
        [self endRefreshing];
    }];
}

- (void)endRefreshing {
    [self.contentCollectionView.mj_header endRefreshing];
    [self.contentCollectionView.mj_footer endRefreshing];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 2;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = nil;
    
    CommentModel *news = [self.dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.item == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentHeader" forIndexPath:indexPath];
    }
    else if (indexPath.item == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentContentCell" forIndexPath:indexPath];
    }
    
    [cell bindWithModel:news];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    BreakNews *news = [self.dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.item == 0) {
        size = [CommentHeader sizeWithModel:nil];
    }
    else if (indexPath.item == 1) {
        size = [CommentContentCell sizeWithModel:news];
    }
    return size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
