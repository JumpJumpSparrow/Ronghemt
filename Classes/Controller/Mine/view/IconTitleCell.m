//
//  IconTitleCell.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "IconTitleCell.h"
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIColor+YYAdd.h>
@interface IconTitleCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation IconTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.textColor = [UIColor colorWithHexString:AppColorNormal];
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    return self;
}

- (void)bindWithModel:(id)model {
    [super bindWithModel:model];
    self.iconImageView.image = [UIImage imageNamed:[model objectForKey:@"icon"]];
    self.textLabel.text = [model objectForKey:@"title"];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.iconImageView.frame = CGRectMake(0, 0, 25.0f, 25.0f);
    self.iconImageView.center = CGPointMake(self.iconImageView.width/2.0f + 10.0f, self.height/2.0f);
    self.textLabel.center = CGPointMake(self.iconImageView.right + self.textLabel.width/2.0f + 10, self.height/2.0f);
}

@end
