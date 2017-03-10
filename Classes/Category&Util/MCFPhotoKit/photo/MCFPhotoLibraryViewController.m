//
//  MCFPhotoLibraryViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFPhotoLibraryViewController.h"
#import "MCFAssetItemCell.h"
#import "MCFAssetCollecitonCell.h"
#import "MCFAssetCollectionView.h"
#import "MCFPhotoLibrary.h"
#import <YYKit.h>
#import "MCFImagePreViewViewController.h"

@interface MCFPhotoLibraryViewController ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHFetchResult *assets;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *collectionSelectButton;
@property (nonatomic, strong) UILabel *photoCountLabel;
@property (nonatomic, strong) UIButton *nextStepButton;

@property (nonatomic, strong) MCFAssetCollectionView *collectionSelectView;

@property (nonatomic, strong) UICollectionView *assetsCollectionView;
@end

@implementation MCFPhotoLibraryViewController

- (instancetype)init {
    if (self = [super init]) {
        NSArray<PHAssetCollection *> *assetCollections = [MCFPhotoLibrary fetchAssetCollections];
        self.assetCollection = [assetCollections firstObject];
        self.assets = [MCFPhotoLibrary fetchAssetsInAssetCollection:self.assetCollection];
    }
    return self;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:AppColorSelected] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(didSelectCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)collectionSelectButton {
    if (!_collectionSelectButton) {
        _collectionSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionSelectButton setTitle:self.assetCollection.localizedTitle forState:UIControlStateNormal];
        [_collectionSelectButton setTitleColor:[UIColor colorWithHexString:AppColorSelected] forState:UIControlStateNormal];
        [_collectionSelectButton setImage:[UIImage imageNamed:@"nav_publish_arrow_down"] forState:UIControlStateNormal];
        [_collectionSelectButton setImage:[UIImage imageNamed:@"nav_publish_arrow_up"] forState:UIControlStateSelected];
        [_collectionSelectButton sizeToFit];
        [_collectionSelectButton addTarget:self action:@selector(didSelectCollectionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionSelectButton;
}

- (UICollectionView *)assetsCollectionView {
    if (!_assetsCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 4;
        layout.minimumLineSpacing = 4;
        _assetsCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _assetsCollectionView.backgroundColor = [UIColor whiteColor];
        _assetsCollectionView.delegate = self;
        _assetsCollectionView.dataSource = self;
        _assetsCollectionView.alwaysBounceVertical = YES;
        [_assetsCollectionView registerClass:[MCFAssetItemCell class] forCellWithReuseIdentifier:@"MCFAssetItemCell"];
    }
    return _assetsCollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.navigationItem.titleView = self.collectionSelectButton;
    
    [self.view addSubview:self.assetsCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didSelectCancel {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didSelectCollectionButton {
    self.collectionSelectButton.userInteractionEnabled = NO;
    
    if (self.collectionSelectButton.selected) {
        self.collectionSelectButton.selected = NO;
        [self hideCollectionSelectView];
    } else {
        self.collectionSelectButton.selected = YES;
        [self showCollectionSelectView];
    }
    
}
- (void)showCollectionSelectView {
    @synchronized (self) {
        
        if (self.collectionSelectView) return;
        
        self.collectionSelectView = [[MCFAssetCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
        self.collectionSelectView.top = self.view.bottom;
        @weakify(self)
        self.collectionSelectView.assetCollectionHandler = ^(PHAssetCollection *assetCollection) {
            @strongify(self)
            self.assetCollection = assetCollection;
            self.assets = [MCFPhotoLibrary fetchAssetsInAssetCollection:assetCollection];
            [self.collectionSelectButton setTitle:assetCollection.localizedTitle forState:UIControlStateNormal];
            [self.collectionSelectButton sizeToFit];
            [self.assetsCollectionView scrollToTopAnimated:NO];
            [self.assetsCollectionView reloadData];
            
            self.collectionSelectButton.selected = NO;
            [self hideCollectionSelectView];
        };
        [self.tabBarController.view addSubview:self.collectionSelectView];
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self.collectionSelectView.top = 64;
                         } completion:^(BOOL finished) {
                             self.collectionSelectButton.userInteractionEnabled = YES;
                         }];
    }
}

- (void)hideCollectionSelectView {
    @synchronized (self) {
        
        if (!self.collectionSelectView) return;
        
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self.collectionSelectView.top = self.tabBarController.view.bottom;
                         } completion:^(BOOL finished) {
                             self.collectionSelectButton.userInteractionEnabled = YES;
                             [self.collectionSelectView removeFromSuperview];
                             self.collectionSelectView = nil;
                         }];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    MCFAssetItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MCFAssetItemCell" forIndexPath:indexPath];
    [cell bindWithModel:asset];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    return [MCFAssetItemCell sizeWithModel:asset];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MCFAssetItemCell *cell = (MCFAssetItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    PHAsset *asset = (PHAsset *)cell.model;
    [MCFPhotoLibrary requestImageForAsset:asset completion:^(UIImage *image, NSDictionary *infor) {
        MCFImagePreViewViewController *preViewVc = [[MCFImagePreViewViewController alloc] initWithImage:image];
        [self.navigationController pushViewController:preViewVc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
