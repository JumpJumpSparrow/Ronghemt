//
//  TextContentCell.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/13.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "TextContentCell.h"

@interface TextContentCell ()

@property (nonatomic, strong) UILabel *contentTextLabel;
@end

@implementation TextContentCell

- (UILabel *)contentTextLabel {
    if (_contentTextLabel == nil) {
        _contentTextLabel = [TextContentCell contentLabel];
    }
    return _contentTextLabel;
}

+ (UILabel *)contentLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13.0f];
    return label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self.contentView addSubview:self.contentTextLabel];
    return self;
}

- (void)bindWithModel:(id)model {
    [super bindWithModel:model];
    BreakNews *news = (BreakNews *)model;
    self.contentTextLabel.text = news.content;
    [self setNeedsLayout];
}

+ (CGSize)sizeWithModel:(id)model{
    
    UILabel *label = [TextContentCell contentLabel];
    BreakNews *news = (BreakNews *)model;
    label.text = news.content;
    CGSize size = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    size.width += 20;
    return CGSizeMake(SCREEN_WIDTH, size.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.contentTextLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    self.contentTextLabel.frame = CGRectMake(10.0f, 0.0f, size.width, size.height);
}


@end
