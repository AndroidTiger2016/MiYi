//
//  MiYiAssetPreviewView.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

@interface MiYiAssetPreviewView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView * scrollView;

@property (nonatomic, weak) UIImageView * imageView;

@property (nonatomic, strong) ALAsset * set;

- (void)reuse;

@property (nonatomic, strong) NSCache * cache;

@end
