//
//  MiYiProductDetailsVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiProductDetailsVC.h"
#import "MiYiProductDetailsView.h"

@interface MiYiProductDetailsVC ()

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation MiYiProductDetailsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITableView *tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-64}];
    [self.view addSubview:tableView];
    MiYiProductDetailsView *detailsView =[[MiYiProductDetailsView alloc]init];
    detailsView.frame=(CGRect){0,0,kWindowWidth,kWindowHeight-64};
    detailsView.viewController=self;
    detailsView.model=_model;
    tableView.tableHeaderView =detailsView;


}


@end
