//
//  MCFPhotoLibraryViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"
#import "MCFPhotoLibrary.h"

@protocol MCFPhotoDelegate <NSObject>

- (void)MCFPhotoLibraryDidSelectImages:(NSArray *)images;
@end

@interface MCFPhotoLibraryViewController : BaseViewController

@property (nonatomic, assign) NSInteger limitCount;
@property (nonatomic, assign) BOOL selectImageToCrop;
@property (nonatomic, weak) id<MCFPhotoDelegate>delegate;
@end
