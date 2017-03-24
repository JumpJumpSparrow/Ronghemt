//
//  MCFPhotoLibrary.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
@interface MCFPhotoLibrary : NSObject

+ (void)checkCameraAuthorization:(UIViewController *)viewController
                      completion:(void (^)(AVAuthorizationStatus status))completion;

+ (void)checkAuthorization:(UIViewController *)viewController
                completion:(void (^)(PHAuthorizationStatus status))completion;

+ (NSArray<PHAssetCollection *> *)fetchAssetCollections;

+ (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection;

+ (void)requestThumbnailForAssetCollection:(PHAssetCollection *)assetCollection
                                completion:(void (^)(UIImage *image))completion;

+ (void)requsetThumbnailForAsset:(PHAsset *)asset
                      completion:(void (^)(UIImage *image))completion;

+ (void)requestImageForAsset:(PHAsset *)asset
                  completion:(void (^)(UIImage *image, NSDictionary *infor))completion;

+ (void)saveImage:(UIImage *)image
       completion:(void(^)(PHAsset * asset))completion;

@end
