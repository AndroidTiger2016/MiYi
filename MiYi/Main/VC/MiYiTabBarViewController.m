//
//  MiYiTabBarViewController.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiTabBarViewController.h"
#import "MiYiTabBar.h"
#import "MiYiNavViewController.h"
#import "MiYiHomeVC.h"
#import "MIYiCommunityVC.h"
#import "UIImage+MiYi.h"
#import "AwesomeMenu.h"
#import "MiYiPhotoLibraryViewController.h"
#import "GPUImageGaussianBlurFilter.h"
#import <UIImageView+WebCache.h>
@interface MiYiTabBarViewController ()<MiYiTabBarDelegate,AwesomeMenuDelegate>
//自定义的tabbar
@property (nonatomic, weak  ) MiYiTabBar      *customTabBar;

@property (nonatomic, weak  ) MiYiHomeVC      *home;//蜜意

@property (nonatomic, weak  ) MIYiCommunityVC *community;//社区

@property (nonatomic, weak  ) AwesomeMenu     *menu;

@property (nonatomic, strong) CAGradientLayer *gradient;

@property (nonatomic, weak  ) UIImageView          *viewHUD;

@property (nonatomic, weak  ) AwesomeMenuItem *item;

@end

@implementation MiYiTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabbar];
    
    [self setupAllChildViewControllers];
    
    [self addAwesomeMenu];
    
    
    
    [Notification addObserver:self selector:@selector(circleClick) name:MiYiTabBarViewControllerTabBarCircle object:nil];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    // 删除系统自动生成的UITabBarButton
    [self removeTabBarButton];
    
}

-(void) removeTabBarButton {
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    MiYiTabBar *customTabBar = [[MiYiTabBar alloc] init];
    customTabBar.frame = (CGRect){0,0,kWindowWidth,49};
    customTabBar.delegate = self;
    customTabBar.backgroundColor=[UIColor whiteColor];
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;

}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    //首页
    MiYiHomeVC *home = [[MiYiHomeVC alloc] init];
    [self setupChildViewController:home title:@"蜜意" imageName:@"home_MIYIsquare_gray" selectedImageName:@"home_MIYIsquare_pink"];
    self.home = home;
    
    //社区
    MIYiCommunityVC *community = [[MIYiCommunityVC alloc] init];
    [self setupChildViewController:community title:@"美美搭" imageName:@"home_beautyshow_gray" selectedImageName:@"home_beautyshow_pink"];
    self.community = community;
    
    
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title = title;
    
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    childVc.tabBarItem.selectedImage = selectedImage;
    
    MiYiNavViewController *nav = [[MiYiNavViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

#pragma mark - tabbar的代理方法
/**
 *  监听tabbar按钮的改变
 */
- (void)tabBar:(MiYiTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
    
}

-(void)addAwesomeMenu
{
    
    UIImageView *viewHUD =[[UIImageView alloc]initWithFrame:kScreenBounds];
    viewHUD.userInteractionEnabled=YES;
    viewHUD.hidden=YES;
    [self.view addSubview:viewHUD];
    _viewHUD=viewHUD;
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    _gradient=gradient;
    _gradient.frame = self.view.frame;
    _gradient.colors = [NSArray arrayWithObjects:(id)UIColorRGBA(255/3,96/4,184/4,0.4).CGColor,(id)UIColorRGBA(255/3,96/3,184/3,0.6).CGColor,
                        (id)UIColorRGBA(255/2,96/2,184/2,0.8).CGColor,nil];
    [_viewHUD.layer insertSublayer:_gradient atIndex:0];

    
    
    
    

//    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = viewHUD.bounds;
//    
//    [viewHUD addSubview:visualEffectView];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"beauty-show"]];
    starMenuItem1.textLabel.text=@"美搭秀";
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"find-similar"]];
    starMenuItem2.textLabel.text=@"求同款";
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"find match"]];
    starMenuItem3.textLabel.text=@"求搭配";
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"how-to"]];
    starMenuItem4.textLabel.text=@"怎么穿";
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"home_more"]];
    _item=startItem;
    
    
    CGFloat menuNear =kWindowWidth/2.3;
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:[[UIScreen mainScreen] bounds] startItem:startItem optionMenus:menus];
    menu.backgroundColor=[UIColor clearColor];
    menu.delegate = self;
    menu.menuWholeAngle = M_PI_2 *1.2;//    设置整个菜单角度：
    menu.rotateAngle=-0.95;//    设置旋转角度：
    menu.farRadius = menuNear+10; //    调整反弹的动画：
    menu.endRadius = menuNear-10; //    调整反弹的动画：
    menu.nearRadius = menuNear;//    设置“添加”按钮和菜单项之间的距离：
    menu.animationDuration = 0.3;//弹出动画时间
    menu.startPoint = CGPointMake(kWindowWidth/2, kWindowHeight-[UIImage imageNamed:@"home_more"].size.height/2);//    定位的“添加”按钮的中心：
    [viewHUD addSubview:menu];
    _menu=menu;
    

}
/**
 *  将圆圈召唤出来 ~~
 */
-(void)circleClick
{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 10.0;
    _viewHUD.image = [blurFilter imageByFilteringImage:image];
    [self.tabBar bringSubviewToFront:_viewHUD];
    self.tabBar.hidden=YES;
    _viewHUD.hidden=NO;
    _menu.expanding=!_menu.isExpanding;
}

-(void)circleHidden
{
    _viewHUD.hidden=YES;
    self.tabBar.hidden=NO;

}
-(void)todoSomething:(NSString * )idx
{
    MiYiPhotoLibraryViewController *vc=[[MiYiPhotoLibraryViewController alloc]init];
    MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
    vc.classString =[self class];
    vc.maxSelectCount = 9;

    AwesomeMenuItem *startItem=_menu.menusArray[[idx integerValue]];
    vc.stringTitle=startItem.textLabel.text;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [Notification postNotificationName:MiYiHomeVCStopSlide object:nil];

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:[NSString stringWithFormat:@"%ld",(long)idx]];
    [self performSelector:@selector(todoSomething:) withObject:[NSString stringWithFormat:@"%ld",(long)idx] afterDelay:0.3f];
    
    NSLog(@"%ld",(long)idx);
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{
    NSLog(@"%@",menu);
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    [self circleHidden];
    
    NSLog(@"%@",menu);
}
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    NSLog(@"%@",menu);
}
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    NSLog(@"%@",menu);
}
@end
