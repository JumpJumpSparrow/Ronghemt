//
//  ImageGridCell.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/13.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ImageGridCell.h"
#import <YYKit.h>

CGFloat margin = 10;
CGFloat interval = 10;

@interface ImageButton :UIButton;

@property (nonatomic, strong) UIImageView *contentImageView;
@end

@implementation ImageButton

- (UIImageView *)contentImageView {
    if (_contentImageView == nil) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _contentImageView.clipsToBounds = YES;
    }
    return _contentImageView;
}

- (instancetype)init {
    self = [super init];
    [self addSubview:self.contentImageView];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentImageView.frame = self.bounds;
}

@end

@interface ImageGridCell ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

@implementation ImageGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.buttonArray = [NSMutableArray arrayWithCapacity:0];
    return self;
}

- (void)bindWithModel:(id)model {
    [super bindWithModel:model];
    
    BreakNews *news = (BreakNews *)model;
    NSArray *items = [news.photo1 componentsSeparatedByString:@","];
    int index = 0;
    for (NSString *url in items) {
        if (url.length > 0) {
            ImageButton *button = [[ImageButton alloc] init];
            
            [button.contentImageView setImageWithURL:[NSURL URLWithString:url] placeholder:nil];
            [self.buttonArray addObject:button];
            [self.contentView addSubview:button];
            button.tag = index;
            index += 1;
            [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self setNeedsLayout];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonArray removeAllObjects];
}

- (void)didSelectButton:(ImageButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectNews:index:)]) {
        [self.delegate didSelectNews:self.model index:sender.tag];
    }
}

+ (CGSize)sizeWithModel:(id)model {
    return CGSizeMake(SCREEN_WIDTH, 125.f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = (SCREEN_WIDTH - 2 * margin - interval * 2)/3.0f;
    NSInteger count = self.buttonArray.count;
    
    for (int index = 0; index < count; index ++) {
        ImageButton *button = self.buttonArray[index];
        button.frame = CGRectMake(margin + (interval + width) * index, 10, width, self.height - 20.0f);
    }
}


@end
