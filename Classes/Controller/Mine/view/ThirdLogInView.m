//
//  ThirdLogInView.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "ThirdLogInView.h"
#import <YYKit.h>

@implementation ThirdLogInView

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor colorWithHexString:AppColorNormal];
        _titleLabel.text = @"第三方登录";
        [_titleLabel sizeToFit];
        _titleLabel.center = CGPointMake(self.width/2.0f, _titleLabel.height/2.0f);
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self addSubview:self.titleLabel];
    [self installButton];
    return self;
}

- (void)installButton {
    
    NSArray *titleArray = @[@"QQ", @"微博", @"微信"];
    NSArray *imageNameArray = @[@"img_share_qq", @"img_share_sina", @"img_share_weixin"];
    CGFloat width = 80.0f;
    CGFloat margin = 30.f;
    CGFloat gap = (SCREEN_WIDTH - width * 3 - margin * 2)/2.0f;
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [button setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        button.center = CGPointMake(margin + (i + 0.5) * width + gap * i, button.height / 2.0f + 30);
        button.tag = i + 1;
        [button addTarget:self action:@selector(didSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = titleArray[i];
        label.textColor = [UIColor colorWithHexString:AppColorNormal];
        label.font = [UIFont systemFontOfSize:16.0f];
        [label sizeToFit];
        label.center = CGPointMake(button.centerX, button.bottom + label.height / 2.0f + 5);
        [self addSubview:label];
        
        if (i != 1){
            CALayer *line = [[CALayer alloc] init];
            line.backgroundColor = APPGRAY.CGColor;
            line.frame = CGRectMake(0, 0, self.titleLabel.left - 20, 0.5);
            line.center = CGPointMake(button.centerX, self.titleLabel.centerY);
            [self.layer addSublayer:line];
        }
    }
    
}

- (void)didSelectIndex:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didSelectLoginMethod:)]) {
        [self.delegate didSelectLoginMethod:button.tag];
    }
}

@end
