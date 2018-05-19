//
//  MiYiMyFriendsVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/16.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiMyFriendsVC.h"
#import "MiYiConcernedWithTheFansRequest.h"
#import "YXLDisplayListView.h"
#import "MIYIConcernVC.h"
#import "MiYiFansVC.h"
@interface MiYiMyFriendsVC ()

@end

@implementation MiYiMyFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HEX_COLOR_VIEW_BACKGROUND;
    
    YXLDisplayListView * displylist =[[YXLDisplayListView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-64}];
    NSLog(@"%f",kWindowHeight);
    MIYIConcernVC * item1 = [[MIYIConcernVC alloc]init];
    item1.viewController=self;
    item1.view.backgroundColor=[UIColor whiteColor];
    item1.title=@"关注";
    
    MiYiFansVC * item2 = [[MiYiFansVC alloc]init];
    item2.viewController=self;
    item2.view.backgroundColor=[UIColor whiteColor];
    item2.title=@"粉丝";
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
