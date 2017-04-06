//
//  CommentListViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentListViewController : BaseViewController

- (instancetype)initWithGlobalId:(NSInteger)globalId;
- (instancetype)initWithPageInfo:(NSDictionary *)infoDict;
@end
