//
//  MiYiCommunityPostDetailsVC.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/19.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"
#import "MiYiBaseCommunityModel.h"
@interface MiYiCommunityPostDetailsVC : MiYiBaseViewController

@property (nonatomic ,strong) MiYiBaseCommunityModel *model;

@property (nonatomic ,assign) BOOL isSelectImage;

@property (nonatomic ,copy) void (^popBlock)();

@end
