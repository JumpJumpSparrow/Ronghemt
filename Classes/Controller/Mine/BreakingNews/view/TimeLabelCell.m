//
//  TimeLabelCell.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/13.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "TimeLabelCell.h"
#import <YYKit.h>

@interface TimeLabelCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation TimeLabelCell

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self.contentView addSubview:self.timeLabel];
    return self;
}

- (void)bindWithModel:(id)model {
    [super bindWithModel:model];
    BreakNews *news = (BreakNews *)model;
    self.timeLabel.text = [news.time substringToIndex:16];
    [self setNeedsLayout];
}

+ (CGSize)sizeWithModel:(id)model {
    return CGSizeMake(SCREEN_WIDTH, 30.0f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.timeLabel sizeToFit];
    
    self.timeLabel.center = CGPointMake(self.width - self.timeLabel.width/2.0f - 10.0f, self.timeLabel.height/2.0f );
}


@end
