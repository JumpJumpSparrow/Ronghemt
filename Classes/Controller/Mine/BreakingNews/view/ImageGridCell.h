//
//  ImageGridCell.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/13.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "BreakNews.h"

@protocol ImageDetailDelegat <NSObject>

- (void)didSelectNews:(BreakNews *)news index:(NSInteger)index;

@end

@interface ImageGridCell : BaseCollectionViewCell

@property (nonatomic, weak) id<ImageDetailDelegat>delegate;
@end
