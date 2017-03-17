//
//  CommentBar.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/15.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "CommentBar.h"
#import <YYKit/UIView+YYAdd.h>

@interface CommentBar ()

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *commentListButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) CALayer *line;
@end

@implementation CommentBar

- (UIButton *)commentButton {
    if (_commentButton == nil) {
        _commentButton = [[UIButton alloc] init];
        [_commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.tag = 0;
    }
    return _commentButton;
}

- (UIButton *)commentListButton {
    if (_commentListButton == nil) {
        _commentListButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
        [_commentListButton setImage:[UIImage imageNamed:@"commentlist"] forState:UIControlStateNormal];
        [_commentListButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        _commentListButton.tag = 1;
    }
    return _commentListButton;
}

- (UIButton *)collectButton {
    if (_collectButton == nil) {
        _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
        [_collectButton setImage:[UIImage imageNamed:@"collection_nor"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"collection_sel"] forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        _collectButton.tag = 2;
    }
    return _collectButton;
}

- (UIButton *)shareButton {
    if (_shareButton == nil) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
        [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.tag = 3;
    }
    return _shareButton;
}

- (CALayer *)line {
    if (_line == nil) {
        _line = [[CALayer alloc] init];
        _line.backgroundColor = APPGRAY.CGColor;
    }
    return _line;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.commentButton];
    [self addSubview:self.commentListButton];
    [self addSubview:self.collectButton];
    [self addSubview:self.shareButton];
    [self.layer addSublayer:self.line];
    return self;
}

- (void)setCollectButtonSellected:(BOOL)isSellected {
    self.collectButton.selected = isSellected;
}

- (void)didSelectButton:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(didSelectCommentIndex:)]) {
        [self.delegate didSelectCommentIndex:sender];
        if(sender.tag == 2) sender.selected = !sender.selected;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.commentButton sizeToFit];
    self.commentButton.center = CGPointMake(self.commentButton.width/2.0f + 10, self.height/2.0f);
    
    CGFloat width = self.width - self.commentButton.right;
    CGFloat gap = (width - 44.0f*3)/4;
    self.commentListButton.center = CGPointMake(self.commentButton.right + gap + 22.0f, self.height/2.0f);
    self.collectButton.center = CGPointMake(self.commentListButton.right + gap + 22.0f, self.height/2.0f);
    self.shareButton.center = CGPointMake(self.collectButton.right + gap + 22.0f, self.height/2.0f);
    self.line.frame = CGRectMake(0, 0, self.width, 0.5);
}

@end
