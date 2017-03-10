//
//  MCFPhotoLibrary.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface MCFPhotoLibrary : NSObject

+ (void)checkAuthorizationCompletion:(void (^)(PHAuthorizationStatus status))completion;

+ (NSArray<PHAssetCollection *> *)fetchAssetCollections;

+ (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection;

+ (void)requestThumbnailForAssetCollection:(PHAssetCollection *)assetCollection completion:(void (^)(UIImage *image))completion;

+ (void)requsetThumbnailForAsset:(PHAsset *)asset completion:(void (^)(UIImage *image))completion;

+ (void)requestImageForAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *infor))completion;

+ (void)saveImage:(UIImage *)image completion:(void(^)(PHAsset * asset))completion;

@end
