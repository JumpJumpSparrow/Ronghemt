//
//  MCFPhotoLibrary.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/3/6.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFPhotoLibrary.h"

static NSString *MCFPhotoPath = @"MCFPhotoLibrary";
@implementation MCFPhotoLibrary

//  请求权限


+ (void)checkCameraAuthorization:(UIViewController *)viewController
                      completion:(void (^)(AVAuthorizationStatus))completion {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (completion) {
                    completion(authStatus);
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            if (completion) {
                completion(authStatus);
            }
            break;
        }
        case AVAuthorizationStatusRestricted: {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"无法授权使用相机"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (completion) {
                                                                      completion(authStatus);
                                                                  }
                                                              }]];
            [viewController presentViewController:alertController animated:YES completion:NULL];
            break;
        }
        case AVAuthorizationStatusDenied:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"请先授权\"新闻媒体\"使用\"相机\""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"暂不允许"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (completion) {
                                                                      completion(authStatus);
                                                                  }
                                                              }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"马上设置"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (completion) {
                                                                      completion(authStatus);
                                                                  }
                                                                  if (SYSTEM_VERSION_NOT_LESS_THAN(@"10.0")){
                                                                      NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                      [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
                                                                  } else if (SYSTEM_VERSION_NOT_LESS_THAN(@"8.0")) {
                                                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=com.hlss.Ronghemt"]];
                                                                  }
                                                              }]];
            [viewController presentViewController:alertController animated:YES completion:NULL];
            
            if (completion) {
                completion(authStatus);
            }
            break;
        }
        default:
            break;
    }
}

+ (void)checkAuthorization:(UIViewController *)viewController
                completion:(void (^)(PHAuthorizationStatus))completion {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (completion) {
                    completion(status);
                }
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized:{
            if (completion) {
                completion(status);
            }
            break;
        }
        case PHAuthorizationStatusRestricted: {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"无法授权使用相册"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (completion) {
                                                                      completion(PHAuthorizationStatusRestricted);
                                                                  }
                                                              }]];
            [viewController presentViewController:alertController animated:YES completion:NULL];
            break;
        }
        case PHAuthorizationStatusDenied:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"请先授权\"新闻媒体\"使用\"照片\""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"暂不允许"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (completion) {
                                                                      completion(PHAuthorizationStatusDenied);
                                                                  }
                                                              }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"马上设置"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (completion) {
                                                                      completion(PHAuthorizationStatusDenied);
                                                                  }
                                                                  if (SYSTEM_VERSION_NOT_LESS_THAN(@"10.0")){
                                                                      NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                      [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
                                                                  } else if (SYSTEM_VERSION_NOT_LESS_THAN(@"8.0")) {
                                                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=com.hlss.Ronghemt"]];
                                                                  }
                                                              }]];
            [viewController presentViewController:alertController animated:YES completion:NULL];

            if (completion) {
                completion(status);
            }
            break;
        }
        default:
            break;
    }
}

+ (NSArray<PHAssetCollection *> *)fetchAssetCollections {
    NSMutableArray *collections = [[NSMutableArray alloc] initWithCapacity:0];
    {//相机胶卷
        PHFetchResult *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                             options:nil];
        
        for (PHCollection *collection in cameraRoll) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *result = [MCFPhotoLibrary fetchAssetsInAssetCollection:assetCollection];
                if (result.count > 0) [collections addObject:assetCollection];
            }
        }
    }
    
    //智能相册
    {
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                              subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                              options:nil];
        for (PHCollection *collection in smartAlbums) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *result = [MCFPhotoLibrary fetchAssetsInAssetCollection:assetCollection];
                if (result.count > 0) [collections addObject:assetCollection];
            }
        }
    }
    // 用户
    {
        PHFetchResult *userCollection = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
        for (PHCollection *collection in userCollection) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *result = [MCFPhotoLibrary fetchAssetsInAssetCollection:assetCollection];
                if (result.count > 0) [collections addObject:assetCollection];
            }
        }
    }
    
    return collections;
}

+ (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@",@[@(PHAssetMediaTypeImage)]];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];;
    return assetsFetchResult;
}

+ (void)requestThumbnailForAssetCollection:(PHAssetCollection *)assetCollection completion:(void (^)(UIImage *))completion {
    PHFetchResult *assetsFetchResult = [MCFPhotoLibrary fetchAssetsInAssetCollection:assetCollection];
    if (assetsFetchResult.count > 0) {
        PHAsset *asset = [assetsFetchResult firstObject];
        [self requsetThumbnailForAsset:asset completion:^(UIImage *image) {
            if (completion) {
                completion(image);
            }
        }];
    }else {
        if (completion) {
            completion(nil);
        }
    }
}

+ (void)requsetThumbnailForAsset:(PHAsset *)asset completion:(void (^)(UIImage *))completion {
    CGFloat expecteWitdh = 220.0f;
    CGSize size = CGSizeMake(expecteWitdh, expecteWitdh);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [[MCFPhotoLibrary defaultCachingImageManager] requestImageForAsset:asset
                                                            targetSize:size
                                                           contentMode:PHImageContentModeAspectFill
                                                               options:options
                                                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                             if (completion) {
                                                                 completion(result);
                                                             }
        
    }];
}

+ (void)requestImageForAsset:(PHAsset *)asset completion:(void (^)(UIImage *, NSDictionary *))completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    CGFloat width = asset.pixelWidth;
    CGFloat height = asset.pixelHeight;
    CGSize size = CGSizeMake(width, height);
    [[MCFPhotoLibrary defaultCachingImageManager] requestImageForAsset:asset
                                                            targetSize:size
                                                           contentMode:PHImageContentModeAspectFill
                                                               options:options
                                                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downLoadFinished = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downLoadFinished && result && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            if (completion) {
                completion(result, info);
            }
        }
    }];
}

+ (PHCachingImageManager *)defaultCachingImageManager {
    static PHCachingImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PHCachingImageManager alloc] init];
    });
    return manager;
}

+ (void)saveImage:(UIImage *)image completion:(void (^)(PHAsset *))completion {
    PHFetchResult *topLevelUserCollections = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    PHAssetCollection *MCFAssetCollection = nil;
    for (PHAssetCollection *ac in topLevelUserCollections) {
        if ([ac.localizedTitle isEqualToString:MCFPhotoPath]) {
            MCFAssetCollection = ac;
            break;
        }
    }
    
    if (MCFAssetCollection == nil) {
        __block NSString *assetCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            assetCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:MCFPhotoPath].placeholderForCreatedAssetCollection.localIdentifier;;
        } error:nil];
        MCFAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionID] options:nil].firstObject;
    }
    
    __block NSString *assetId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
    
    NSError *error;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:MCFAssetCollection];
        [request insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    if (completion) {
        completion(asset);
    }
}

@end
