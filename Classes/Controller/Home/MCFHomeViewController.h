//
//  MCFHomeViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"

@class MCFNaviModel;
@interface MCFHomeViewController : BaseViewController


- (instancetype)initWithChannels:(MCFNaviModel *)naviModel;
- (void)loadChannels:(MCFNaviModel *)naviModel;
@end
