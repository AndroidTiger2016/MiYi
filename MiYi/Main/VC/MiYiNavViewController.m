//
//  MiYiNavViewController.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiNavViewController.h"
#import "UIImage+MiYi.h"
@interface UINavigationController ()<UIGestureRecognizerDelegate>

@end
@implementation MiYiNavViewController

+ (void)initialize
{
    [self setupBarButtonItemTheme];
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    
    UINavigationBar * navBar = [UINavigationBar appearance];
    //    //将UIColor转成图片设置背景RGB(107,89,229)
    UIImage *image =[UIImage createImageWithColor:UIColorRGBA(255,255,255,1)];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [dic setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    navBar.titleTextAttributes = dic;
    navBar.tintColor=UIColorRGBA(155, 155, 155, 1) ;
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count != 1) {
            return YES;
        }else
            return NO;
    }
    return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
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
