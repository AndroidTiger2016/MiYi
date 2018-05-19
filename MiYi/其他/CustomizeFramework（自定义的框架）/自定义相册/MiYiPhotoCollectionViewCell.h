//
//  MiYiPhotoCollectionViewCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiYiPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *maskView;

@property (nonatomic) BOOL photoSelect;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *selectedView;

@end
