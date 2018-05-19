//
//  DynamicScrollView.h
//  MeltaDemo
//
//  Created by hejiangshan on 14-8-27.
//  Copyright (c) 2014年 hejiangshan. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "MiYiMenuSentModel.h"
#import "MiYiImageView.h"
@interface DynamicScrollView : UIView

@property (nonatomic ,weak) UIViewController *viewController;


- (id)initWithFrame:(CGRect)frame withImages:(MiYiMenuSentModel *)images;

@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)MiYiMenuSentModel *imageS;

@property(nonatomic, strong)NSMutableArray *imageViews;

@property(nonatomic,assign)BOOL isDeleting;

@property (nonatomic ,assign) BOOL isAddImage;

@property (nonatomic ,strong) MiYiImageView *addImage;;

@property (nonatomic ,assign) BOOL isMenu;

- (void)initViews;
@end
