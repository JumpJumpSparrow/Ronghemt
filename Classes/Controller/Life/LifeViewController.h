//
//  LifeViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"

@class MCFNaviModel;
@interface LifeViewController : BaseViewController
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)loadChannels:(MCFNaviModel *)naviModel;
@end
