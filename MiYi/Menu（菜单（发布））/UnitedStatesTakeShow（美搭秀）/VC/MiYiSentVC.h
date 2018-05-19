//
//  MiYiSentVC.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/28.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"
#import "MiYiMenuSentModel.h"
@interface MiYiSentVC : MiYiBaseViewController

@property (nonatomic ,strong)MiYiMenuSentModel *model;

@property (nonatomic ,copy) void (^dynamicRefreshBlock)();

@end
