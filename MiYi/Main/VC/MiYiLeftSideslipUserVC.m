//
//  MiYiLeftSideslipUserVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/21.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiLeftSideslipUserVC.h"
#import "LeftSideslipButton.h"
#import "UIImage+MiYi.h"
#import "MiYiUser.h"
#import <UIImageView+WebCache.h>
#import "MiYiView.h"
#import "MiYiUserVC.h"
#import "MiYiUserRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiLoginVC.h"
#import "MiYiNavViewController.h"
#import "MiYiSettingVC.h"
#import "MiYiUserSession.h"
#import "MiYiMyWardrobeVC.h"
#import "MiYiMyFriendsVC.h"
#import "MiYiMyActivityVC.h"
@interface MiYiLeftSideslipUserVC ()
{
    UIView *viewImageUserBackground;
    UIImageView *imageUser;
    UILabel *labelUserName;
    UIButton *buttonRating;
    UILabel *labelFans;
    UILabel *labelSignaturre;
    
}

@property (nonatomic ,strong) NSMutableArray *buttonArray;

@end

@implementation MiYiLeftSideslipUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self userUI];
    
}

-(void)userUI
{
    MiYiAccount *user =[[MiYiUser shared]accountUser];
    
    
    viewImageUserBackground = [self getViewImageUserBackground];
    [UIImage hexagonPathWidth:67.5 view:viewImageUserBackground];
    [self.view addSubview:viewImageUserBackground];
    [viewImageUserBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.left.equalTo(@50);
        make.size.mas_equalTo(CGSizeMake(67.5, 67.5));
    }];
    
    imageUser = [self getImageUser];
    [UIImage hexagonPathWidth:61.5 view:imageUser];
    [imageUser sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    [viewImageUserBackground addSubview:imageUser];
    [imageUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewImageUserBackground);
        make.size.mas_equalTo(CGSizeMake(61.5, 61.5));
    }];
    
    labelUserName = [self getLabelUserName];
    labelUserName.text=user.nickname ? user.nickname :@"";
    [self.view addSubview:labelUserName];
    [labelUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewImageUserBackground.mas_bottom).offset(25/2);
        make.left.equalTo(viewImageUserBackground);
        make.height.greaterThanOrEqualTo(@17);
        make.width.greaterThanOrEqualTo(@20);
    }];
    
    buttonRating = [self getButtonRating];
    NSString *ratingText =[NSString stringWithFormat:@" %@",user.exp_point ? user.exp_point :@"时尚新手"];
    [buttonRating setTitle:ratingText forState:UIControlStateNormal];
    [buttonRating sizeToFit];
    [self.view addSubview:buttonRating];
    [buttonRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelUserName.mas_bottom).offset(10);
        make.left.equalTo(viewImageUserBackground);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonRating.frame)));
        make.height.equalTo(@(CGHeight(buttonRating.frame)));
    }];
    
    NSArray *leftSideslipIconArray =@[@"Personal_message",@"Personal_closet",@"Personal_mythread",@"Personal_friends",@"Personal_setting"];
    NSArray *leftSideslipTextArray =@[@"  动态",@"  衣橱",@"  蜜信",@"  好友",@"  设置"];
    
    
    for (int i=0; i<leftSideslipTextArray.count; i++) {
        UIButton *btn =[self getLeftSideslipButton];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [btn setImage:[UIImage imageNamed:leftSideslipIconArray[i]] forState:UIControlStateNormal];
        [btn setTitle:leftSideslipTextArray[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:HEX_COLOR_THEME] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buttonRating.mas_bottom).offset(35+49*i);
            make.left.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(kWindowWidth*0.8, 49));
        }];
        [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(@50);
            make.size.mas_equalTo(CGSizeMake(CGWidth(btn.imageView.frame), CGHeight(btn.imageView.frame)));
        }];
        [btn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(btn.imageView.mas_right);
            make.size.mas_equalTo(CGSizeMake(CGWidth(btn.titleLabel.frame), CGHeight(btn.titleLabel.frame)));
        }];
    }
    
    UIButton *viewUserBackground =[UIButton new];
    [viewUserBackground addTarget:self action:@selector(clickViewUserBackground) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewUserBackground];
    [viewUserBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(kWindowWidth*0.8));
        make.bottom.equalTo(buttonRating.mas_bottom);
    }];
    
    
    UIView *preventMultipleTapView =[UIView new];
    [self.view addSubview:preventMultipleTapView];
    _preventMultipleTapView=preventMultipleTapView;
    [preventMultipleTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth*0.8, kWindowHeight));
    }];
    
    
    
}

/**
 *  点击进入个人中心
 */
-(void)clickViewUserBackground{
    _preventMultipleTapView.hidden=NO;
    MiYiUserVC *vc =[[MiYiUserVC alloc]init];
    vc.uid=[MiYiUserSession shared].session.uid;
    [Notification postNotificationName:MiYiHomeVCjumpVC object:vc];
    
}

-(void)clickBtn:(UIButton *)btn{
    _preventMultipleTapView.hidden=NO;
    if (btn.tag == 0) {
        // 动态
        MiYiMyActivityVC *vc =[[MiYiMyActivityVC alloc]init];
        [Notification postNotificationName:MiYiHomeVCjumpVC object:vc];
    }else if (btn.tag == 1) {
        // 衣橱
        MiYiMyWardrobeVC *vc =[[MiYiMyWardrobeVC alloc]init];
        vc.uid=[MiYiUserSession shared].session.uid;
        [Notification postNotificationName:MiYiHomeVCjumpVC object:vc];
    }else if (btn.tag == 2) {
        
    }else if (btn.tag == 3) {
        // 好友
        MiYiMyFriendsVC *vc = [[MiYiMyFriendsVC alloc] init];
        [Notification postNotificationName:MiYiHomeVCjumpVC object:vc];
    }else if (btn.tag == 4) {
        //设置
        MiYiSettingVC *settingVC = [[MiYiSettingVC alloc] init];
        [Notification postNotificationName:MiYiHomeVCjumpVC object:settingVC];
    }
}




-(void)userData:(MiYiAccount *)user
{
    
    [imageUser sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];;
    labelUserName.text =user.nickname? user.nickname :@"好懒哦,名字都不起";
    [buttonRating setTitle:user.exp_point ?user.exp_point :@"时尚新手" forState:UIControlStateNormal];
//    labelFans.text=user.follower ? user.follower :@"无";
//    labelSignaturre.text=user.summary ? user.summary :@"";

}

-(UIView *)getViewImageUserBackground{
    UIView *view =[UIView new];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

-(UIImageView *)getImageUser{
    UIImageView *image =[UIImageView new];
    image.contentMode=UIViewContentModeScaleAspectFill;
    return image;
}

-(UILabel *)getLabelUserName{
    UILabel *label =[UILabel new];
    label.font=boldFont(16);
    label.textColor=[UIColor whiteColor];
    return label;
}

-(UIButton *)getButtonRating{
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"Personal_Star"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=Font(12);
    return btn;
}

-(UIButton *)getLeftSideslipButton{
    UIButton *btn =[UIButton new];
    btn.adjustsImageWhenHighlighted=NO;
    btn.titleLabel.font = boldFont(16);
    [btn setExclusiveTouch:YES];
    return btn;
}
-(void)dealloc
{
    
}
@end
