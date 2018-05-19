//
//  MiYiPhotoGroupListView.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MiYiGroupAsset;

typedef void (^MiYiPhotoGroupListSelectBlock)(MiYiGroupAsset * selectGroup);

@interface MiYiPhotoGroupListView : UIView

+ (instancetype)showToView:(UIView *)view block:(MiYiPhotoGroupListSelectBlock)block;

@property (nonatomic, copy) MiYiPhotoGroupListSelectBlock block;

- (void)dismiss;

@end
