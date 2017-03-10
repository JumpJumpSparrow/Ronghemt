//
//  MCFAssetCollectionView.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFAssetCollectionView.h"
#import "MCFAssetCollecitonCell.h"
#import <YYKit.h>
#import "MCFPhotoLibrary.h"
#import <Photos/Photos.h>

@interface MCFAssetCollectionView ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<PHAssetCollection *> *assetCollections;
@end

@implementation MCFAssetCollectionView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 12.0f;
        layout.itemSize = CGSizeMake(self.width - 2*10.0f, 79);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        [_collectionView registerClass:[MCFAssetCollecitonCell class] forCellWithReuseIdentifier:@"MCFAssetCollecitonCell"];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.assetCollections = [MCFPhotoLibrary fetchAssetCollections];
        [self addSubview:self.collectionView];
    }
    return self;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetCollections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *assetCollection = [self.assetCollections objectAtIndex:indexPath.item];
    MCFAssetCollecitonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MCFAssetCollecitonCell" forIndexPath:indexPath];
    [cell bindWithModel:assetCollection];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *assetCollection = [self.assetCollections objectAtIndex:indexPath.item];
    if (self.assetCollectionHandler) {
        self.assetCollectionHandler(assetCollection);
    }
}

@end
