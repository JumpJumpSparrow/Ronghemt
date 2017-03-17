//
//  CommentBar.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/15.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentBarDelegate <NSObject>

- (void)didSelectCommentIndex:(UIButton *)sender;
@end

@interface CommentBar : UIView

@property (nonatomic, weak) id<CommentBarDelegate>delegate;
- (void)setCollectButtonSellected:(BOOL)isSellected;
@end
