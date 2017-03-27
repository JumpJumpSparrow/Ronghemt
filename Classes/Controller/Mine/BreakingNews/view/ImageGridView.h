//
//  MCFImageGridView.h.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/24.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageGridDelegate <NSObject>

- (void)imageGrideDidSelectAddImageButton;
@optional
- (void)deletSelectedItemAtIndex:(NSInteger)index;
- (void)displySelectedImage:(UIImage *)image;
@end

@interface ImageGridView : UIView

@property (nonatomic, assign) NSInteger limitCount;
@property (nonatomic, weak) id<ImageGridDelegate>delegate;

- (void)loadImages:(NSArray *)images;
@end
