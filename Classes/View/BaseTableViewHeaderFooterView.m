//
//  BaseTableViewHeaderFooterView.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseTableViewHeaderFooterView.h"

@implementation BaseTableViewHeaderFooterView

- (void)bindWithModel:(id)model {
    _model = model;
}

+ (CGFloat)heightWithModel:(id)model {
    return 0.f;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _model = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end
