//
//  MCFNaviModel.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFBaseModel.h"

@interface MCFNaviModel : MCFBaseModel

@property (nonatomic, assign) NSInteger navigationId;
@property (nonatomic, copy) NSString *navigationName;
@property (nonatomic, copy) NSString *navigationUrl;
@property (nonatomic, strong) NSArray <MCFNaviModel *>*data;
@end
