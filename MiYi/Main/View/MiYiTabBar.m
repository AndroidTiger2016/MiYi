//
//  MiYiTabBar.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiTabBar.h"
#import "MiYiTabBarButton.h"
#import "MiYiImageView.h"
@interface MiYiTabBar()
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) UIButton *plusButton;
@property (nonatomic, weak) MiYiTabBarButton *selectedButton;
@end

@implementation MiYiTabBar
- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        UIImage *imagemore =[UIImage imageNamed:@"home_more"];
        MiYiImageView *image =[[MiYiImageView alloc]initWithFrame:(CGRect){{kWindowWidth/2-imagemore.size.height/2,-(imagemore.size.height-49)},imagemore.size}];
        image.image =imagemore;
        [image addTarget:self action:@selector(imageClick) forControlEvents:MiYiImageViewControlEventTap];
        image.userInteractionEnabled=YES;
        [self addSubview:image];
    }
    return self;
}
-(void)imageClick
{
    [Notification postNotificationName:MiYiTabBarViewControllerTabBarCircle object:nil];
}
- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
   
    MiYiTabBarButton *button = [[MiYiTabBarButton alloc] init];
    [self addSubview:button];
    
    [self.tabBarButtons addObject:button];
    
    button.item = item;
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(MiYiTabBarButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    
    
    
    
    CGFloat buttonH = 49;
    CGFloat buttonW = w / 3;
    CGFloat buttonY = h==149?100:0;
    
    for (int index = 0; index<self.tabBarButtons.count; index++) {
        
        MiYiTabBarButton *button = self.tabBarButtons[index];
        
        CGFloat buttonX = index * buttonW;
        if(index ==1)
        {
            button.frame = CGRectMake(buttonX+buttonW, buttonY, buttonW, buttonH);
        }else
        {
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        }
        
        button.tag = index;
    }
    
   
}



@end
