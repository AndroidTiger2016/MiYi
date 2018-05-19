//
//  MiYiMyActivityVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/17.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiMyActivityVC.h"
#import "YXLDisplayListView.h"
#import "MiYiMyReleaseVC.h"
#import "MiYiMyLoveVC.h"
#import "MiYiUserSession.h"
@interface MiYiMyActivityVC ()

@end

@implementation MiYiMyActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    YXLDisplayListView * displylist =[[YXLDisplayListView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-64}];
    MiYiMyReleaseVC * item1 = [[MiYiMyReleaseVC alloc]init];
    item1.viewController=self;
    item1.uid=[MiYiUserSession shared].session.uid;
    item1.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    item1.title=@"我的发布";
    
    MiYiMyLoveVC * item2 = [[MiYiMyLoveVC alloc]init];
    item2.viewController=self;
    item2.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    item2.title=@"我的喜欢";
    
    NSArray * controllers = @[item1,item2];
    
    //是否需要顶部下划线
    displylist.isNeedTopUnderline = YES;
    //这里是更改顶部滑动字体颜色
    displylist.tabItemSelectedColor = UIColorFromRGB_HEX(0XFF60BB);
    displylist.topUnderlineBackgroundColor =HEX_COLOR_THEME;
    displylist.topBackgroundColor=[UIColor whiteColor];
    //添加控制器到数组topBackgroundColor
    displylist.viewControllers = controllers;
    [self.view addSubview:displylist];
    
    // Do any additional setup after loading the view.
}


@end
