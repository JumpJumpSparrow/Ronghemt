//
//  MCFImageCropView.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/2.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MCFImageCropViewDataSource;
@protocol MCFImageCropViewDelegate;

typedef NS_ENUM(NSUInteger, MCFImageCropMode) {
    MCFImageCropModeCircle,
    MCFImageCropModeSquare,
    MCFImageCropModeCustom
};

@interface MCFImageCropView : UIView

@property (nonatomic, weak, nullable) id<MCFImageCropViewDelegate>delegate;
@property (nonatomic, weak, nullable) id<MCFImageCropViewDataSource>dataSource;

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, copy) UIColor *maskLayerColor;
@property (nonatomic, assign) CGFloat maskLayerLineWidth;
@property (nonatomic, copy, nullable) UIColor *maskLayerStrokeColor;
@property (nonatomic, readonly, assign) CGRect maskRect;
@property (nonatomic, readonly, copy) UIBezierPath *maskPath;
@property (nonatomic, assign) MCFImageCropMode cropMode;
@property (nonatomic, readonly, assign) CGRect cropRect;
@property (nonatomic, readonly, assign) CGFloat rotationAngle;
@property (nonatomic, readonly, assign) CGFloat zoomScale;
@property (nonatomic, assign) BOOL avoidEmptySpaceAroundImage;
@property (nonatomic, assign) BOOL applyMaskToCroppedImage;
@property (nonatomic, getter=isRotationEnabled, assign) BOOL rotationEnabled;
@property (nonatomic, assign) CGFloat portraitCircleMaskRectInnerEdgeInset;
@property (nonatomic, assign) CGFloat portraitSquareMaskRectInnerEdgeInset;

- (void)cropImage;
- (void)cancelCrop;
@end

@protocol MCFImageCropViewDataSource <NSObject>

- (CGRect)imageCropViewCustomMaskRect:(MCFImageCropView *)view;
- (UIBezierPath *)imageCropViewCustomMaskPath:(MCFImageCropView *)view;
@optional
- (CGRect)imageCropViewCustomMovementRect:(MCFImageCropView *)view;

@end

@protocol MCFImageCropViewDelegate <NSObject>
@optional
- (void)imageCropViewDidCancelCrop:(MCFImageCropView *)view;
- (void)imageCropView:(MCFImageCropView *)view willCropImage:(UIImage *)originalImage;
- (void)imageCropView:(MCFImageCropView *)view didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect;
- (void)imageCropView:(MCFImageCropView *)view didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle;
@end

NS_ASSUME_NONNULL_END


