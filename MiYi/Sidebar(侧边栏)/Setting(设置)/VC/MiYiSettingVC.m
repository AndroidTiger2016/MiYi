//
//  MiYiSettingVC.m
//  MiYi
//
//  Created by huangzheng on 8/25/15.
//  Copyright (c) 2015 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiSettingVC.h"
#import "MiYiItemGroup.h"
#import "MiYiSwitchItem.h"
#import "MiYiArrowItem.h"
#import "MiYiWelcome.h"
#import "MiYiUser.h"
@interface MiYiSettingVC ()

@end

@implementation MiYiSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}


- (void) initUI {
    
        self.title = @"设置";
        self.view.backgroundColor = HEX_COLOR_VIEW_BACKGROUND;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRect) {0, kWindowHeight *0.8, kWindowWidth, 60}];
        UIButton *exitBtn = [[UIButton alloc] initWithFrame:(CGRect){0,16,kWindowWidth,44}];
        [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        exitBtn.titleLabel.font = Font(15);
        [exitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [exitBtn setBackgroundColor:[UIColor whiteColor]];
        [exitBtn addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.tableFooterView addSubview:exitBtn];
    
        [self addOne];
        [self addTow];
        [self addTree];

}

- (void) exitLogin {
    [MiYiUser clearMessage]; // 清除用户信息
    [self.navigationController popViewControllerAnimated:NO];
    MiYiWelcome *welcome = [[MiYiWelcome alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = welcome;
    
}

-(void)addOne
{
    MiYiItemGroup *group=[self addGroup];
    MiYiSwitchItem *message = [MiYiSwitchItem itemWithTitle:@"消息提醒"];
    MiYiSwitchItem *position = [MiYiSwitchItem itemWithTitle:@"打开定位"];
    MiYiArrowItem *clearCache = [MiYiArrowItem itemWithTitle:@"清除缓存"];


    
    
    group.items=@[message, position, clearCache];
}

-(void)addTow
{
    MiYiItemGroup *group=[self addGroup];
    MiYiArrowItem *feedback = [MiYiArrowItem itemWithTitle:@"意见反馈"];
    MiYiArrowItem *softwareEvalution = [MiYiArrowItem itemWithTitle:@"软件评价"];
    
    group.items=@[feedback,softwareEvalution];
}
- (void) addTree {
    MiYiItemGroup *group=[self addGroup];
    MiYiArrowItem *userprotocol = [MiYiArrowItem itemWithTitle:@"用户协议"];
    MiYiArrowItem *aboutMiyi = [MiYiArrowItem itemWithTitle:@"关于蜜意"];
//    aboutMiyi.operation = nil;// ^{ // 测试
    
//        MiYiAddUserInfoVC *addUserInfoVC = [[MiYiAddUserInfoVC alloc] init];
//        NSArray *images = [NSArray arrayWithObjects:@"AmericaStyle", @"clearStyle", @"JSStyle", @"LeisureStyle", @"qingshuStyle", @"retoStyle", @"schoolStyle", @"sengnvStyle", @"sportStyle",nil];
//        NSArray *titles = [NSArray arrayWithObjects:@"欧美风", @"小清新", @"日韩范", @"休闲", @"轻熟", @"复古", @"学院风", @"森女系", @"运动", nil];
//        
//        NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
//        for (int i = 0; i < images.count; i++) {
//            content[images[i]] = titles[i];
//        }
//        
//        [addUserInfoVC setInit:@"你的日常穿着更接近那种风格呢" withImage:@"style" withContent:content withPos:1];
//        [self.navigationController pushViewController:addUserInfoVC animated:YES];
//    };
    
    group.items=@[userprotocol,aboutMiyi];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
    [Notification removeObserver:self];
}


@end
