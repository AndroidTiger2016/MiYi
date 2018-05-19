//
//  UIImage+MiYi.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "UIImage+MiYi.h"

@implementation UIImage (MiYi)
/**
 * 将UIColor变换为UIImage
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
+ (UIImage *)circleImage:(UIImage *)imageV borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIImage *oldImage = imageV;
    
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(ctx);
    
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


/**
 *
 *  @param viewWidth 设置这个六边形的宽度
 *  @param view      设置那个控件需要
 */

+(void)hexagonPathWidth:(int)viewWidth view:(id)view
{
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    path.lineWidth = 2;
    
//    [[UIColor colorWithRed:0. green:0. blue:0. alpha:1.] setStroke];
    
    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
    
    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
    
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
    
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
    
    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
    
    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    
    [path closePath];
    
    CAShapeLayer * shapLayer = [CAShapeLayer layer];
    
    shapLayer.lineWidth = 1;
    
    shapLayer.strokeColor = [UIColor whiteColor].CGColor;
    
    shapLayer.path = path.CGPath;
    
    [view layer].mask=shapLayer;
    [view layer].masksToBounds=YES;
    
}
@end
