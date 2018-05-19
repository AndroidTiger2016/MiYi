//
//  MIYiCommunityVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MIYiCommunityVC.h"
#import "YXLDisplayListView.h"
#import "MiYiCommunityOne.h"
#import "MiYiCommunityTwo.h"
#import "MiYiCommunityThree.h"
#import "MiYiCommunityFour.h"
#import "YXLBottomScrollView.h"
#import "UIImage+MiYi.h"
@interface MIYiCommunityVC ()

@end

@implementation MIYiCommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    YXLDisplayListView *Display =[[YXLDisplayListView alloc]initWithFrame:(CGRect){0,26,kWindowWidth,kWindowHeight}];
    
    
    MiYiCommunityOne * item1 = [[MiYiCommunityOne alloc]init];
    item1.viewController=self;
    item1.view.backgroundColor=[UIColor whiteColor];
    item1.title=@"美搭秀";
    
    MiYiCommunityTwo * item2 = [[MiYiCommunityTwo alloc]init];
    item2.viewController=self;
    item2.view.backgroundColor=[UIColor whiteColor];
    item2.title=@"求同款";
    
    MiYiCommunityThree * item3 = [[MiYiCommunityThree alloc]init];
    item3.viewController=self;
    item3.view.backgroundColor=[UIColor whiteColor];
    item3.title=@"求搭配";
    
    MiYiCommunityFour * item4 = [[MiYiCommunityFour alloc]init];
    item4.viewController=self;
    item4.view.backgroundColor=[UIColor whiteColor];
    item4.title=@"怎么穿";
    
  
    
    NSArray * controllers = @[item1,item2,item3,item4];
    Display.kBtnWInt=4;
    
    //是否需要顶部下划线
    Display.isNeedTopUnderline = YES;
    //这里是更改顶部滑动字体颜色
    Display.tabItemSelectedColor = UIColorFromRGB_HEX(0XFF60BB);
    Display.topUnderlineBackgroundColor =HEX_COLOR_THEME;
    Display.topBackgroundColor=[UIColor whiteColor];
    //添加控制器到数组topBackgroundColor
    Display.viewControllers = controllers;
    

    
    
    [self.view addSubview:Display];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hiddenNavigationBarWhenViewWillAppear=YES;
        
    }
    return self;
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
