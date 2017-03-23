//
//  MCFImageCropViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/22.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"

@interface MCFImageCropViewController : BaseViewController

@property (nonatomic, copy) void(^didCropImage)(UIImage *cropedImage);

- (instancetype)initWithImage:(UIImage *)image;
@end
