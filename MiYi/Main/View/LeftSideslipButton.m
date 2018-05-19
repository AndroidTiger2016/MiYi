//
//  LeftSideslipButton.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/27.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "LeftSideslipButton.h"

@interface LeftSideslipButton()
@property (nonatomic, strong) UIFont *titleFont;
@end
@implementation LeftSideslipButton

/**
 *  通过代码创建控件的时候就会调用
 */
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
 *  初始化
 */
- (void)setup
{
    self.titleFont = boldFont(16);
    self.titleLabel.font = self.titleFont;
    
    
    // 图标居中
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


/**
 *  控制器内部label的frame
 *  contentRect : 按钮自己的边框
 */
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleX = kWindowWidth*0.15+20+5;
//    CGFloat titleY = 0;
//    NSDictionary *attrs = @{NSFontAttributeName : self.titleFont};
//    CGFloat titleW;
//    
//    titleW = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
//    // titleW = [self.currentTitle sizeWithFont:self.titleFont].width;
//    CGFloat titleH = contentRect.size.height;
//    return CGRectMake(titleX, titleY, titleW, titleH);
//}
//
///**
// *  控制器内部imageView的frame
// */
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat imageW = 20;
//    CGFloat imageX = kWindowWidth*0.15;
//    CGFloat imageY = contentRect.size.height/2-20/2;
//    CGFloat imageH = 20;
//    return CGRectMake(imageX, imageY, imageW, imageH);
//}
@end
