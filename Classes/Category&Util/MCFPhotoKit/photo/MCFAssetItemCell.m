//
//  MCFAssetItemCell.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFAssetItemCell.h"
#import <YYKit.h>
#import <Photos/Photos.h>
#import "MCFPhotoLibrary.h"

@interface MCFAssetItemCell ()
@property (nonatomic, strong) UIImageView *assetImageView;
@property (nonatomic, strong) UIImageView *checkImageView;
@end

@implementation MCFAssetItemCell

- (UIImageView *)assetImageView {
    if (!_assetImageView) {
        _assetImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _assetImageView.clipsToBounds = YES;
        _assetImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _assetImageView;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"asset_check_normal"]];
        [_checkImageView sizeToFit];
        _checkImageView.center = CGPointMake(self.contentView.width - 5 - _checkImageView.width/2,
                                             5 + _checkImageView.height/2);
    }
    return _checkImageView;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.assetImageView.image = nil;
    self.checkImageView.hidden = YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.assetImageView];
        [self.contentView addSubview:self.checkImageView];
    }
    return self;
}

+ (CGSize)sizeWithModel:(id)model {
    CGFloat width = (SCREEN_WIDTH - 2 * 4) / 3;
    return CGSizeMake(width, width);
}

- (void)bindWithModel:(id)model {
    [super bindWithModel:model];
    
    PHAsset *asset = (PHAsset *)model;
    [MCFPhotoLibrary requsetThumbnailForAsset:asset completion:^(UIImage *image) {
        self.assetImageView.image = image;
    }];
}

- (void)markCheck:(BOOL)check {
    self.checkImageView.hidden = !check;
}
@end
