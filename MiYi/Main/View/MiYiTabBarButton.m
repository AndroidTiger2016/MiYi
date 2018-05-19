//
//  MiYiTabBarButton.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiTabBarButton.h"

// 图标的比例
#define YXLTabBarButtonImageRatio 0.4
// 按钮的默认文字颜色
#define  YXLTabBarButtonTitleColor [UIColor grayColor]


@implementation MiYiTabBarButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 图标居中
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.hidden = YES;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        // 文字颜色
        [self setTitleColor:YXLTabBarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:HEX_COLOR_THEME forState:UIControlStateSelected];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width ;
    CGFloat imageH = contentRect.size.height * YXLTabBarButtonImageRatio;
    
    return CGRectMake(0, 7, imageW, imageH);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * YXLTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY+2, titleW, titleH);
}

// 设置item
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    // KVO 监听属性改变
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}
/**
 *  监听到某个对象的属性改变了,就会调用
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 设置文字
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    // 设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
}


@end
