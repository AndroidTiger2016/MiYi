//
//  MiYiProductDetailsView.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiRecommendModel.h"
@interface MiYiProductDetailsView : UIView

@property (nonatomic ,strong) MiYiRecommendModel *model;

@property (nonatomic ,weak) UIViewController *viewController;

@end
