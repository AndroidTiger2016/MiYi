//
//  MiYiSideslipVC.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/21.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"
#import "MiYiLeftSideslipUserVC.h"
#import "MiYiTabBarViewController.h"
@interface MiYiSideslipVC : MiYiBaseViewController

/**
 *  实例化
 */
+ (MiYiSideslipVC *)shared;

/**
 *  速度系数-建议在0.5-1之间。默认为0.5
 */
@property (assign,nonatomic ) CGFloat                  speed;

@property (nonatomic ,strong) MiYiLeftSideslipUserVC   * leftControl;
@property (nonatomic ,strong) MiYiTabBarViewController * mainControl;


@property (nonatomic ,strong) UIImageView              * imgBackground;

-(void)initWithLeftView:(MiYiLeftSideslipUserVC *)LeftView
            andMainView:(MiYiTabBarViewController *)MainView
     andBackgroundImage:(UIImage *)image;

@end
