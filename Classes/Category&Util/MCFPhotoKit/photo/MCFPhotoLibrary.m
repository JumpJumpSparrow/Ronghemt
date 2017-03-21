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
+ (void)checkAuthorizationCompletion:(void (^)(PHAuthorizationStatus))completion {
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
        case PHAuthorizationStatusAuthorized:
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:{
            
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
