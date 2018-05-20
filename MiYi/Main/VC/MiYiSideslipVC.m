//
//  MiYiSideslipVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/21.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiSideslipVC.h"
#import "UIView+YXL3D.h"
#import "UIImage+Reflection.h"
#import "MiYiUserSession.h"
#import "MiYiUser.h"
#import <UIImageView+WebCache.h>
//#import "MiYiHomeVC.h"
#import "MiYiNavViewController.h"
#import "MiYiUserVC.h"
#import "MiYiSettingVC.h"
#import "MiYiUserVC.h"
#import "MiYiMyWardrobeVC.h"
#import "MiYiMyFriendsVC.h"
#import "MiYiMyActivityVC.h"
@interface MiYiSideslipVC ()

@property (nonatomic ,weak) UIView *viewClick;

@property (nonatomic ,weak) UITapGestureRecognizer *sideslipTapGes;

@property (nonatomic ,strong) UIImageView *viewImage;



@end

@implementation MiYiSideslipVC


+ (MiYiSideslipVC *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        MiYiTabBarViewController *mian =[[MiYiTabBarViewController alloc]init];
        MiYiLeftSideslipUserVC *left =[[MiYiLeftSideslipUserVC alloc]init];
        [instance initWithLeftView:left andMainView:mian andBackgroundImage:[UIImage imageNamed:@"Personal_background"]];
    });
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.view addSubview:mainControl.view];
    
}




-(void)initWithLeftView:(MiYiLeftSideslipUserVC *)LeftView
            andMainView:(MiYiTabBarViewController *)MainView
     andBackgroundImage:(UIImage *)image;
{
    
    
    _speed =0.5;
    
    _leftControl = LeftView;
    _mainControl = MainView;
    
    UIImageView * imgview = [UIImageView new];
    
    [imgview setImage:image];
    [self.view addSubview:imgview];
    [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    //单击手势
    UITapGestureRecognizer *sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
    [sideslipTapGes setNumberOfTapsRequired:1];
    _sideslipTapGes=sideslipTapGes;
    
    UIView *viewClick =[[UIView alloc]initWithFrame:_mainControl.view.bounds];
    [_mainControl.view addSubview:viewClick];
    viewClick.hidden=YES;
    _viewClick = viewClick;
    [viewClick addGestureRecognizer:_sideslipTapGes];
    
    _leftControl.view.backgroundColor=[UIColor clearColor];
    
    
    
    
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:(CGRect){0,kWindowHeight+20,kWindowWidth,kWindowHeight}];
    
    [_mainControl.view addSubview:imageView];
    _viewImage =imageView;
    
    
    _leftControl.view.hidden=YES;
    
    
    [self.view addSubview:_leftControl.view];
    
    [self.view addSubview:_mainControl.view];
    
    [Notification addObserver:self selector:@selector(sideslipNotification) name:MiYiSideslipVCSideslipNotification object:nil];
    
    [Notification addObserver:self selector:@selector(jumpNotification:) name:MiYiHomeVCjumpVC object:nil];
    
}


-(void)sideslipNotification
{
    
    //    MiYiSession *session =[[MiYiUserSession shared]session];
    //    MiYiAccount *accountUser =[[MiYiUser shared]accountUser];
    //    NSLog(@"%@=====\n======%@",session,accountUser);
#warning 清除图片缓存
//    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    //    [imageCache clearMemory];
    //    [imageCache clearDiskOnCompletion:^{
    //        NSLog(@"imageCache清楚");
    //    }];
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_viewImage setImage:[image reflectionWithAlpha:0.3]];
    _viewImage.transform=CGAffineTransformMakeRotation(M_PI*2);
    
    _viewClick.hidden=NO;
    _leftControl.view.hidden=NO;
    _leftControl.preventMultipleTapView.hidden=YES;
    [UIView animateWithDuration:_speed animations:^{
        [_mainControl.view setProgess:0.8 degrees:25 Zposition:400];
        _mainControl.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/2);
    }completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UITapGestureRecongnizer start");
    }
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self recovery];
        
    }
    
}

-(void)recovery
{
    [UIView animateWithDuration:_speed animations:^{
        [_mainControl.view setProgess:1 degrees:0 Zposition:400];
        _mainControl.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    }completion:^(BOOL finished) {
        [_mainControl.view setProgess:1 degrees:0 Zposition:0];
        
        _leftControl.view.hidden=YES;
        _viewClick.hidden=YES;
        
    }];
}
/**
 *  个人中心跳转
 */
-(void)jumpNotification:(NSNotification *)notification
{
    id classString =[notification object];
    MiYiNavViewController *nav=(MiYiNavViewController *)_mainControl.childViewControllers[0];
    
    if ([classString isKindOfClass:[MiYiUserVC class]]) {
        
        MiYiUserVC *vc = (MiYiUserVC *)classString;
        vc.hidesBottomBarWhenPushed=YES;
        [nav pushViewController:classString animated:YES];
        
    } else if ([classString isKindOfClass:[MiYiSettingVC class]]) {
        
        MiYiSettingVC *settingVC = classString;
        settingVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:settingVC animated:YES];
        
    }else if ([classString isKindOfClass:[MiYiMyWardrobeVC class]])
    {
        MiYiMyWardrobeVC *vc = classString;
        vc.title=@"我的衣橱";
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    }else if ([classString isKindOfClass:[MiYiMyFriendsVC class]])
    {
        MiYiMyFriendsVC *vc = classString;
        vc.title=@"我的好友";
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    }else if ([classString isKindOfClass:[MiYiMyActivityVC class]])
    {
        MiYiMyActivityVC *vc = classString;
        vc.title=@"我的动态";
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    }
    else
    {
        UIViewController *vc =[[UIViewController alloc]init];
        vc.view.backgroundColor=[UIColor whiteColor];
        vc.hidesBottomBarWhenPushed=YES;
        [nav pushViewController:vc animated:YES];
    }
    
    [self recovery];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    
}

-(void)dealloc
{
    
}
@end
