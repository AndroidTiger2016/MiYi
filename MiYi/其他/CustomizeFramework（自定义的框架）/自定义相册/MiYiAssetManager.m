//
//  MiYiAssetManager.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiAssetManager.h"
#import <UIKit/UIKit.h>

@interface MiYiAssetManager ()
{
    ALAssetsLibrary * library;
    NSMutableArray * mediaArray;
    NSMutableArray * grounpArray;
}

@property (nonatomic) BOOL isLoading;
@end

@implementation MiYiAssetManager

static MiYiAssetManager * assetManager = nil;

+ (instancetype)shareAssetManager
{
    if (!assetManager) {
        assetManager = [[MiYiAssetManager alloc]init];
    }
    return assetManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLibrary:) name:ALAssetsLibraryChangedNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)updateLibrary:(NSNotification *)not
{
    [self refresh];
}

- (void)refresh
{
    if (self.isLoading) {
        return;
    }
    if (!library) {
        library = [[ALAssetsLibrary alloc]init];
    }
    grounpArray = [NSMutableArray array];
    self.isLoading = YES;
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group) {
             NSLog(@"group %@",group);
             [grounpArray addObject:[[MiYiGroupAsset alloc]initWithGroup:group]];
         }else
         {
             _didRefresh = YES;
             self.isLoading = NO;
             [self callbackOnMainThread];
         }
         
     }failureBlock:^(NSError * error)
     {
         _didRefresh = YES;
         self.isLoading = NO;
         [self failedCallbackOnMainThread:error];
     }];
}

- (NSArray *)groupList
{
    return grounpArray;
}

- (void)callbackOnMainThread
{
    if ([NSThread isMainThread] == NO) {
        [self performSelectorOnMainThread:@selector(callbackOnMainThread) withObject:nil waitUntilDone:YES];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetManagerDidRefresh:)]) {
        [self.delegate assetManagerDidRefresh:self];
    }
}

- (void)failedCallbackOnMainThread:(NSError *)error
{
    if ([NSThread isMainThread] == NO) {
        [self performSelectorOnMainThread:@selector(failedCallbackOnMainThread:) withObject:error waitUntilDone:YES];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetManager:refreshFailedWithError:)]) {
        [self.delegate assetManager:self refreshFailedWithError:error];
    }
}

- (void)addNewImage:(UIImage *)image metaData:(NSDictionary *)metaData completion:(MiYiAssetManagerAddNewImageCompletion)completion
{
    [library writeImageToSavedPhotosAlbum:image.CGImage metadata:metaData completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            if (completion) {
                completion (nil);
            }
        }else
        {
            [self refresh];
            
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                if (completion) {
                    completion(asset);
                }
            } failureBlock:^(NSError *error) {
                if (completion) {
                    completion(nil);
                }
            }];
        }
    }];
}

@end

@interface MiYiGroupAsset ()

//@property (nonatomic, copy)XXAssetManagerBlock block;

@end

@implementation MiYiGroupAsset

- (id)initWithGroup:(ALAssetsGroup *)group
{
    self = [self init];
    if (self) {
        _group = group;
        NSMutableArray * tempArray = [NSMutableArray array];
        
        _isLoading = YES;
        [_group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
         {
             if (result) {
                 NSDictionary * dic = [NSDictionary dictionaryWithObject:result forKey:[NSNumber numberWithInteger:index]];
                 [tempArray addObject:dic];
             }else
             {
                 [tempArray sortUsingComparator:^NSComparisonResult(NSDictionary * dic1, NSDictionary * dic2)
                  {
                      return [[[dic1 allKeys]firstObject]compare:[[dic2 allKeys]firstObject]];
                  }];
                 NSMutableArray * list = [NSMutableArray array];
                 for (int i = 0; i < tempArray.count; i ++) {
                     NSDictionary * tempDic = tempArray[i];
                     [list addObject:[tempDic objectForKey:[[tempDic allKeys]firstObject]]];
                 }
                 _list = list;
                 _isLoading = YES;
                 //                 if (self.block) {
                 //                     self.block (YES, nil);
                 //                 }
                 //                 self.block = nil;
             }
         }];
    }
    return self;
}

//- (BOOL)setLoadingBlock:(XXAssetManagerBlock)block
//{
//    if (self.isLoading) {
//        self.block = block;
//        return YES;
//    }else
//        return NO;
//}

- (NSString *)description
{
    return   [NSString stringWithFormat:@"<%@ :%p group %@ photo %@>",[self class],self, self.group, self.list];
}
@end

@implementation ALAsset (Method)

- (BOOL)isEqual:(id)object
{
    return [[self description]isEqualToString:[object description]];
}
@end
