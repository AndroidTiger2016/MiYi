//
//  MiYiTagEditorImageView.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/15.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiOwnerModel.h"
@interface MiYiTagEditorImageView : UIView

@property (nonatomic ,strong) MiYiPostsImageSModel *postsImageSModel;

/**
 *  初始化标签
 *
 *  @param point   是点击添加的时候  传point point中心点与点击位子差半个标签尺寸所有加了半个尺寸的长度
 不是就为 CGPointZero
 *  @param isClick 是点击添加YES   不是则NO
 *  @param model   当isClick 为NO的时候需要传入数据
 */
-(void)addtagViewimageClickinit:(CGPoint)point isClick:(BOOL)isClick mode:(MiYiPostsImageTagIdsModel *)model;

/**
 *  将数据添加到model对象里面
 */
-(void)returnsData;
/**
 *  删除tag
 */
-(void)removeTag;

/**
 *  计算出这个图片的在屏幕上显示不拉伸的最好的尺寸  并取出比例值
 */
-(void)imageTagFrame:(BOOL)isComputing;
/**
 *  比例值
 */
@property (nonatomic ,assign) CGFloat imageScale;
/**
 *  图片
 */
@property (nonatomic ,weak) UIImageView *previewsImage;
/**
 *  是否是编辑标签的  默认NO不编辑
 */
@property (nonatomic ,assign) BOOL isEditor;
/**
 *  是否计算图片正确的尺寸 默认是计算正确缩放的尺寸
 */
@property (nonatomic ,assign) BOOL isComputing;


@property (nonatomic ,copy) void (^tableViewReloadData)();


@property (nonatomic, weak) UIViewController *viewController;

@end
