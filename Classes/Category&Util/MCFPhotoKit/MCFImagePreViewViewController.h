//
//  MCFImagePreViewViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/2.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"

@interface MCFImagePreViewViewController : BaseViewController

@property (nonatomic, assign) BOOL cropImage;
@property (nonatomic, copy) void(^didSelectImage)(UIImage *image);

- (instancetype)initWithImage:(UIImage *)image;
@end
