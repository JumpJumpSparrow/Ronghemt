//
//  UserHeader.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseTableViewHeaderFooterView.h"

@class MCFUserModel;
@protocol AvatarTapDelegate <NSObject>

- (void)didTapAvatar:(MCFUserModel *)user;
@end

@interface UserHeader : BaseTableViewHeaderFooterView

@property (nonatomic, weak) id<AvatarTapDelegate>delegate;
@end
