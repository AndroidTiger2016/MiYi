//
//  MiYiLeftSideslipUserVC.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/21.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"
@class MiYiAccount;
@interface MiYiLeftSideslipUserVC : MiYiBaseViewController

-(void)userData:(MiYiAccount *)user;

/**
 *  防止多次点击的模盖View
 */
@property (nonatomic ,strong) UIView *preventMultipleTapView;

@end

