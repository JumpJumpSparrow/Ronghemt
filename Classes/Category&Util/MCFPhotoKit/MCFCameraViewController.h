//
//  MCFCameraViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/1.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"

@protocol CameraDataDelegate <NSObject>

- (void)cameraDidSelectImage:(UIImage *)image;
@end

@interface MCFCameraViewController : BaseViewController

@property (nonatomic, assign) BOOL isCropView;
@property (nonatomic, weak) id<CameraDataDelegate>delegate;
@end
