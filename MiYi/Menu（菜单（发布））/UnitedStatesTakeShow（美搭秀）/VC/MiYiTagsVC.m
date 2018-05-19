//
//  MiYiTagsVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/21.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiTagsVC.h"
#import "MiYiTagEditorImageView.h"
#import <Foundation/Foundation.h>

@interface MiYiTagsVC ()

@property (nonatomic, weak) MiYiTagEditorImageView *imageView;


@end

@implementation MiYiTagsVC



- (void)viewDidLoad {
    [super viewDidLoad];
    

    MiYiTagEditorImageView *imageView =[[MiYiTagEditorImageView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-64}];
    imageView.viewController=self;
    imageView.isEditor=YES;
    imageView.postsImageSModel=_model;
    [self.view addSubview:imageView];
    _imageView=imageView;
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;
  
}

-(void)navItemClick
{
    [_imageView returnsData];
    _blockUI();
    [self.navigationController popViewControllerAnimated:YES];
}

@end
