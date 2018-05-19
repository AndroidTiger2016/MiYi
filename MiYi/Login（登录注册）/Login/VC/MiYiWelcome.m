//
//  MiYiWelcome.m
//  MiYi
//
//  Created by huangzheng on 15/7/30.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiWelcome.h"
#import "MiYiSideslipVC.h"
#import "MiYiLeftSideslipUserVC.h"
#import "MiYiTabBarViewController.h"
#import "MiYiLoginVC.h"
#import "UIImage+MiYi.h"
#import "MiYiNavViewController.h"
@interface MiYiWelcome ()
{
    UIImageView *imageBackground;
    UIImageView *imageLogo;
    UILabel *labelIntroduce;
    UIButton *buttonLogin;
    UIButton *buttonTour;
}
@end

@implementation MiYiWelcome

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"";
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    imageBackground = [UIImageView new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"welcome_background@2x" ofType:@"png"];
    imageBackground.image=[[UIImage alloc] initWithContentsOfFile:path];
    [self.view addSubview:imageBackground];
    [imageBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth,kWindowHeight));
    }];
    
    imageLogo = [UIImageView new];
    imageLogo.image=[UIImage imageNamed:@"welcome_logo"];
    [self.view addSubview:imageLogo];
    [imageLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-(imageLogo.image.size.height/2));
        make.size.mas_equalTo(CGSizeMake(imageLogo.image.size.width, imageLogo.image.size.height));
    }];
    
    labelIntroduce = [self getlabelIntroduce];
    labelIntroduce.text=@"享受你的时尚之旅";
    [labelIntroduce sizeToFit];
    [self.view addSubview:labelIntroduce];
    [labelIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageLogo.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.greaterThanOrEqualTo(@100);
    }];
    
    buttonTour = [self getButtonTour];
    [buttonTour setTitle:@"游客登录" forState:UIControlStateNormal];
    buttonTour.layer.cornerRadius=40/2;
    [buttonTour addTarget:self action:@selector(clickTour) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTour];
    [buttonTour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-35);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth*0.8, 40));
    }];
    
    buttonLogin = [self getButtonLogin];
    [buttonLogin setTitle:@"登录" forState:UIControlStateNormal];
    buttonLogin.layer.cornerRadius=40/2;
    [buttonLogin addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonLogin];
    [buttonLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonTour.mas_top).offset(-15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth*0.8, 40));
    }];
    // Do any additional setup after loading the view.
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLogin {
    MiYiLoginVC *logVc = [[MiYiLoginVC alloc] init];
    MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:logVc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)clickTour {
    UIWindow *screenWindow = [[UIApplication  sharedApplication] keyWindow];
    screenWindow.rootViewController = [MiYiSideslipVC shared];
    [Notification postNotificationName:MiYiHomeVCNavItemNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prefersStatusBarHidden];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self prefersStatusBarHidden];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -Mark init
-(UILabel *)getlabelIntroduce{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = Font(20);
    label.textColor = [UIColor whiteColor];
    return label;
}

-(UIButton *)getButtonLogin{
    UIButton *btn = [UIButton new];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.layer.masksToBounds=YES;
    btn.backgroundColor=UIColorRGBA(255, 255, 255, 0.4);
    return btn;
}

-(UIButton *)getButtonTour{
    UIButton *btn = [UIButton new];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = UIColorRGBA(255, 255, 255, 0.4);
    return btn;
}

-(void)dealloc{
    
}


@end
