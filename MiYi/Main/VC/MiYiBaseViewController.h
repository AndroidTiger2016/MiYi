//
//  MiYiBaseViewController.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MiYiStatusBarStyle) {
    MiYiStatusBarStyleNone = 0,
    MiYiStatusBarStyleBlack,
    MiYiStatusBarStyleWhite,
};


@interface MiYiBaseViewController : UIViewController

/**
 *  再navigationController push一个新的界面
 *
 *  @param className class的name 默认按照  [[class alloc]init]方法进行初始化
 */

- (void)pushViewControllerWithClassName:(NSString *)className;

/**
 *  隐藏键盘
 */

- (IBAction)hiddenKeyborad;

/**
 *  回退按钮的事件,默认是navigationController.pop函数
 *
 *  @param sender 可选
 */
- (IBAction)back:(id)sender;

/**
 *  如果为 YES, view did appear时候会取消tableView的选中状态 默认为YES
 */
@property (nonatomic) BOOL deSelectTableViewWhenViewAppear;


/**
 *  如果为 YES  view will apppear的时候会隐藏(YES)/显示(NO)navigationBar
 */
@property (nonatomic) BOOL hiddenNavigationBarWhenViewWillAppear;

/**
 *  标记是否是child view controller
 */
@property (nonatomic) BOOL isChildViewController;

/**
 *  添加返回的navigation item
 */
- (void)addLeftBackItem;

@property (nonatomic, readonly, strong) UIBarButtonItem * backItem;

/**
 *  状态栏的颜色 默认返回 MiYiStatusBarStyleNone 对status bar不做任何修改 需要subclass 重写
 *
 *  @return 看枚举
 */
- (MiYiStatusBarStyle)statusBarStyle;


@end
