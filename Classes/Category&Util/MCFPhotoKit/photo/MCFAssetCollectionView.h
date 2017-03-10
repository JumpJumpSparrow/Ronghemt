//
//  MCFAssetCollectionView.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface MCFAssetCollectionView : UIView

@property (nonatomic, copy) void(^assetCollectionHandler)(PHAssetCollection *);
@end
