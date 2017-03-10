//
//  MCFAssetCollecitonCell.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFAssetCollecitonCell.h"
#import <YYKit.h>
#import <Photos/Photos.h>
#import "MCFPhotoLibrary.h"

@interface MCFAssetCollecitonCell ()

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation MCFAssetCollecitonCell

- (UIImageView *)thumbnailImageView {
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.height, self.contentView.height)];
        _thumbnailImageView.clipsToBounds = YES;
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thumbnailImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.thumbnailImageView.right + 12,
                                                                0,
                                                                self.contentView.width - self.thumbnailImageView.right - 12,
                                                                16)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left,
                                                                0,
                                                                self.titleLabel.width,
                                                                12)];
        _countLabel.font = [UIFont systemFontOfSize:11];
    }
    return _countLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.thumbnailImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.countLabel];
        self.titleLabel.centerY = self.contentView.height/2 - self.countLabel.height/2 - 4;
        self.countLabel.centerY = self.contentView.height/2 + self.titleLabel.height/2 + 4;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.thumbnailImageView.image = nil;
    self.titleLabel.text = @"";
    self.countLabel.text = @"";
}

+ (CGSize)sizeWithModel:(id)model {
    return CGSizeMake(SCREEN_WIDTH, 79);
}

- (void)bindWithModel:(id)model {
    [super bindWithModel:model];
    
    PHAssetCollection *assetCollection = (PHAssetCollection *)model;
    [MCFPhotoLibrary requestThumbnailForAssetCollection:assetCollection
                                            completion:^(UIImage *image) {
                                                self.thumbnailImageView.image = image;
                                            }];
    self.titleLabel.text = assetCollection.localizedTitle;
    PHFetchResult *result = [MCFPhotoLibrary fetchAssetsInAssetCollection:assetCollection];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", result.count];
}

@end
