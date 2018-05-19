//
//  MiYiTabBar.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MiYiTabBar;

@protocol MiYiTabBarDelegate <NSObject>

- (void)tabBar:(MiYiTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface MiYiTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;


@property (nonatomic, weak) id<MiYiTabBarDelegate> delegate;
@end
