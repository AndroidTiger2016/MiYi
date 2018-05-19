//
//  MiYiDynamicScrollView.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/15.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiMenuSentModel.h"
#import "MiYiImageView.h"

@interface MiYiDynamicScrollView : UIView
/**
 *  控件
 */
@property (nonatomic ,strong) NSMutableArray *imageViews;
/**
 *  父控件
 */
@property (nonatomic ,weak) UIViewController *viewController;
/**
 *  赋值数据
 */
@property (nonatomic ,strong)MiYiMenuSentModel *menuSentModel;
/**
 *  添加图片按钮控件
 */
@property (nonatomic ,weak) MiYiImageView *addImage;;
/**
 *  是否需要边框
 */
@property (nonatomic ,assign) BOOL isMenu;
/**
 *  是否需要删除
 */
@property (nonatomic,assign)BOOL isDeleting;
/**
 *  删除图片UI
 */
-(void)removeUI;

/**
 *  回调block  回调选中的index  与  图片或者url
 */
@property (nonatomic ,copy) void (^imageRefreshBlock)(NSString * imageIndex ,id image);
@end
