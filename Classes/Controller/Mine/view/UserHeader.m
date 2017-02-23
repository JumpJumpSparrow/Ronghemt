//
//  UserHeader.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "UserHeader.h"
#import <YYKit.h>
#import "MCFUserModel.h"
@interface UserHeader ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation UserHeader

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        self.avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.backgroundImageView];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    @weakify(self)
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(didTapAvatar:)]) {
            [self.delegate didTapAvatar:self.model];
        }
    }];
    [self.avatarImageView addGestureRecognizer:tapGesture];
    return self;
}

- (void)bindWithModel:(id)model {
    [super bindWithModel:model];
    MCFUserModel *user = (MCFUserModel *)model;
    @weakify(self)
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:user.avatar]
                                  placeholder:[UIImage imageNamed:@"defaultAvatar"]
                                      options:YYWebImageOptionProgressiveBlur
                                   completion:^(UIImage * _Nullable image,
                                                NSURL * _Nonnull url,
                                                YYWebImageFromType from,
                                                YYWebImageStage stage,
                                                NSError * _Nullable error) {
                                       
                                       @strongify(self)
                                       self.backgroundImageView.image = [image imageByBlurRadius:60
                                                                                       tintColor:[UIColor colorWithWhite:0.84 alpha:0.16]
                                                                                        tintMode:kCGBlendModeNormal
                                                                                      saturation:1.8 maskImage:nil];
    }];
   
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatar]
                                  options:YYWebImageOptionProgressiveBlur];
    self.nameLabel.text = user.username;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    self.avatarImageView.frame = CGRectMake(0, 0, 80.0f, 80.0f);
    self.avatarImageView.layer.cornerRadius = 40.f;
    
    self.avatarImageView.center = CGPointMake(self.width/2.0f, self.height/2.0f - 20.0f);
    
    [self.nameLabel sizeToFit];
    self.nameLabel.center = CGPointMake(self.width/2.0f, self.avatarImageView.bottom + 30.0f);
}

@end
