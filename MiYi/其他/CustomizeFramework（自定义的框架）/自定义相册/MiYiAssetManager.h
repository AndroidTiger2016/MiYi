//
//  MiYiAssetManager.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class MiYiAssetManager;
@class UIImage;

typedef void (^MiYiAssetManagerAddNewImageCompletion) (ALAsset * set);

@protocol MiYiAssetManagerDelegate <NSObject>

@optional

- (void)assetManagerDidRefresh:(MiYiAssetManager *) manager;

- (void)assetManager:(MiYiAssetManager *)manager refreshFailedWithError:(NSError *)error;
@end

@interface MiYiAssetManager : NSObject

+ (instancetype) shareAssetManager;

@property (nonatomic, readonly) NSArray * groupList;

@property (nonatomic, weak) id  <MiYiAssetManagerDelegate>delegate;

@property (nonatomic, readonly) BOOL didRefresh;

- (void)refresh;

- (void)addNewImage:(UIImage *)image metaData:(NSDictionary *)metaData completion:(MiYiAssetManagerAddNewImageCompletion)completion;

@end

@class ALAssetsGroup;

@interface MiYiGroupAsset : NSObject

- (id)initWithGroup:(ALAssetsGroup *)group;

@property (nonatomic, readonly) ALAssetsGroup * group;

@property (nonatomic, readonly) NSMutableArray * list;

@property (nonatomic, readonly) BOOL isLoading;
@end

@interface ALAsset (Method)

@end

@interface Hello : NSObject

@property (nonatomic, strong) NSString * name;

@end
