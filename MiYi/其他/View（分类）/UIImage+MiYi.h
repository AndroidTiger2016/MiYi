//
//  UIImage+MiYi.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MiYi)
/**
 *  将颜色变成image
 *
 *  @param color 颜色值
 *
 *  @return 返回一个带有颜色的image
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**
 *  图片剪裁圆形
 *
 *  @param imageV      需要剪裁图片
 *  @param borderWidth 剪裁后的外圆线的宽度，可为0
 *  @param borderColor 外圆线的颜色，不需要可为nil
 *
 *  @return 返回一个剪裁后的图片
 */
+ (UIImage *)circleImage:(UIImage *)imageV borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *
 *  @param viewWidth 设置这个六边形的宽度
 *  @param view      设置那个控件需要
 */
+(void)hexagonPathWidth:(int)viewWidth view:(id)view;

@end
