//
//  BaseTableViewHeaderFooterView.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, readonly, strong) id model;

- (void)bindWithModel:(id)model;
+ (CGFloat)heightWithModel:(id)model;
@end
