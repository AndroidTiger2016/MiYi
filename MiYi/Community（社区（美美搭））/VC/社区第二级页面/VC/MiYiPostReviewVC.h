//
//  MiYiPostReviewVC.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/18.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"
#import "MiYiBaseCommunityModel.h"
@interface MiYiPostReviewVC : MiYiBaseViewController

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) MiYiBaseCommunityModel *model;

@property (nonatomic ,copy) void (^popBlock)();

@end
