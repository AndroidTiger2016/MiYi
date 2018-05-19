//
//  MiYiPhotosView.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/9.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiYiPhotosView : UIView


@property (nonatomic, strong) NSArray *photos;


+ (CGSize)photosViewSizeWithPhotosCount:(NSInteger)count;

@end
