//
//  MiYiBoxSelectedVC.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/31.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"
#import "BJImageCropper.h"
#import "MiYiMenuSentModel.h"
@interface MiYiBoxSelectedVC : MiYiBaseViewController

/**
 *  这个是显示框选图片 preview  默认不显示
 */
@property (nonatomic ,assign) BOOL SHOW_PREVIEW;
/**
 *  框选的图片  默认不显示
 */
@property (nonatomic, weak) UIImageView *preview;
/**
 *  数据
 */
@property (nonatomic, strong) MiYiPostsImageSModel *model;
/**
 *  返回这个图片的框选的位子
 */
@property (nonatomic ,copy) void (^boundsBlock)(NSString *bounds);

@end
