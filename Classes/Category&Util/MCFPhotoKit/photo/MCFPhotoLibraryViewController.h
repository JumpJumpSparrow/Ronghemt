//
//  MCFPhotoLibraryViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCFPhotoLibraryViewController : UIViewController

@property (nonatomic, assign) NSInteger selectLimit;
@property (nonatomic, assign) BOOL selectImageToCrop;
@property (nonatomic, copy) void(^didSelectedImages)(NSArray *images);
@end
