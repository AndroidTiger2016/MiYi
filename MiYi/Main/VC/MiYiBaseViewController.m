//
//  MiYiBaseViewController.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"

@interface MiYiBaseViewController ()

@end

@implementation MiYiBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hiddenNavigationBarWhenViewWillAppear=NO;
        self.deSelectTableViewWhenViewAppear = YES;
//        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)pushViewControllerWithClassName:(NSString *)className
{
    UIViewController * viewController = [[NSClassFromString(className) alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HEX_COLOR_VIEW_BACKGROUND;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.navigationController.viewControllers.count > 1) {
        [self addLeftBackItem];
    }
}

- (void)addLeftBackItem
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    _backItem = self.navigationItem.leftBarButtonItem;
    
}

- (IBAction)hiddenKeyborad
{
    [self.view endEditing:YES];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
    
    
    
    if (self.deSelectTableViewWhenViewAppear) {
        
        for (UITableView * tableView in self.view.subviews) {
            if ([tableView isKindOfClass:[UITableView class]]) {
                NSIndexPath * indexPath = tableView.indexPathForSelectedRow;
                if (indexPath) {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        }
    }
    
    
    if (self.statusBarStyle != MiYiStatusBarStyleNone) {
        [[UIApplication sharedApplication]setStatusBarStyle:self.statusBarStyle - 1 animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.isChildViewController == NO) {
        [self.navigationController setNavigationBarHidden:self.hiddenNavigationBarWhenViewWillAppear animated:animated];
    }
    
    if (self.statusBarStyle != MiYiStatusBarStyleNone) {
        [[UIApplication sharedApplication]setStatusBarStyle:self.statusBarStyle - 1 animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

//    [MobClick endLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
}

- (void)addChildViewController:(UIViewController *)childController
{
    [super addChildViewController:childController];
    if ([childController isKindOfClass:[MiYiBaseViewController class]]) {
        [(MiYiBaseViewController *)childController setIsChildViewController:YES];
    }
}

- (void)removeFromParentViewController
{
    [super removeFromParentViewController];
    self.isChildViewController = NO;
}

- (MiYiStatusBarStyle)statusBarStyle
{
    return MiYiStatusBarStyleBlack;
}
@end
