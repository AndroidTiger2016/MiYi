//
//  MiYiTagsVC.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/21.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"
#import "MiYiMenuSentModel.h"
@interface MiYiTagsVC : MiYiBaseViewController

@property (nonatomic, strong) MiYiPostsImageSModel  *model;

@property (nonatomic, copy) void (^blockUI)();
@end
