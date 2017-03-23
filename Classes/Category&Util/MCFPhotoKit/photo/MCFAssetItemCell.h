//
//  MCFAssetItemCell.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class MCFAssetItemCell;
@protocol AssetSelectionDelegate <NSObject>

- (void)assetItemCell:(MCFAssetItemCell *)cell didSelect:(BOOL)isSelected;
@end

@interface MCFAssetItemCell : BaseCollectionViewCell

@property (nonatomic, weak) id<AssetSelectionDelegate>delegate;
- (void)markCheck:(BOOL)check;
- (void)hideSelectButton:(BOOL)hide;
@end
