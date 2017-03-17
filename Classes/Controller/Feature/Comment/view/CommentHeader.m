//
//  CommentHeader.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "CommentHeader.h"
#import <YYKit.h>

@interface CommentHeader ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation CommentHeader

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIImageView *)avatarView {
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] init];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    return self;
}

- (void)bindWithModel:(id)model {
    [super bindWithModel:model];
    CommentModel *comment = (CommentModel *)model;
    [self.avatarView setImageWithURL:[NSURL URLWithString:comment.avatar]
                         placeholder:[UIImage imageNamed:@"default"]
                             options:YYWebImageOptionProgressiveBlur
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                
                            } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                                return [image imageByRoundCornerRadius:MAXFLOAT];
                            } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                
                            }];
    
    self.nameLabel.text = comment.username;
    self.timeLabel.text = [comment.date substringToIndex:16];
    [self setNeedsLayout];
}

+ (CGSize)sizeWithModel:(id)model {
    return CGSizeMake(SCREEN_WIDTH, 44.0f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarView.frame = CGRectMake(10.0f, 5, 30.0f, 30.0f);
    [self.nameLabel sizeToFit];
    [self.timeLabel sizeToFit];
    self.nameLabel.center = CGPointMake(self.avatarView.right + self.nameLabel.width/2.0f + 10.0f, self.height/2.0f);
    self.timeLabel.center = CGPointMake(self.width - self.timeLabel.width/2.0f - 10.0f, self.height/2.0f );
}
@end
