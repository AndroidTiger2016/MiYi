//
//  MiYiUserVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiUserVC.h"
#import "MiYiInformationModificationVC.h"
#import "MiYiPersonalUserView.h"
#import "MiYiUserStyleCell.h"
#import "MiYiUserActivityCell.h"
#import "MiYiUserWardrobeCell.h"
#import "MiYiPostsRequest.h"
#import "MiYiBaseCommunityModel.h"
#import <MJExtension.h>
#import "MBProgressHUD+YXL.h"
#import <MJRefresh.h>
#import "MiYiWardrobeRequest.h"
#import "MiYiRecommendModel.h"
#import "MiYiUserRequest.h"
@interface MiYiUserVC ()<UITableViewDataSource,UITableViewDelegate,MiYiUserStyleCellDelegate>
{
    UITableView *tableViewUser;
    MiYiPersonalUserView *viewUser;
    MiYiAccount *user;
    NSMutableArray *arrayActivity;
    NSMutableArray *arrayWardrobe;
    
}
@end

@implementation MiYiUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayActivity=[NSMutableArray array];
    arrayWardrobe =[NSMutableArray array];
    
    if (_isOfOthers!=YES) {
        user=[[MiYiUser shared]accountUser];
    }
    tableViewUser = [self getTableViewUser];
    [self.view addSubview:tableViewUser];
    [tableViewUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    viewUser = [MiYiPersonalUserView new];
    viewUser.uid=_uid;
    viewUser.isOfOthers=_isOfOthers;
    if (_isOfOthers==YES) {
        viewUser.frame=(CGRect){0,0,kWindowWidth,283+(75/2+4)};
    }else{
        viewUser.frame=(CGRect){0,0,kWindowWidth,283};
    }
    viewUser.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    tableViewUser.tableHeaderView=viewUser;
    
    
    [self navItmeInit];
    
    [self userData];
}

-(void)navItmeInit{
    
    UIButton *navItemLeft =[UIButton new];
    [navItemLeft setImage:[UIImage imageNamed:@"Personal_back"] forState:UIControlStateNormal];
    [navItemLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navItemLeft sizeToFit];
    [self.view addSubview:navItemLeft];
    [navItemLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44/2+20-(CGHeight(navItemLeft.frame)+20)/2);
        make.left.equalTo(@(15-10));
        make.size.mas_equalTo(CGSizeMake(CGWidth(navItemLeft.frame)+20, CGHeight(navItemLeft.frame)+20));
    }];
    
    if (_isOfOthers==YES) {
        return;
    }
    
    UIButton *navItemright =[UIButton new];
    [navItemright setImage:[UIImage imageNamed:@"Personal_whiteEdit"] forState:UIControlStateNormal];
    [navItemright addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    [navItemright sizeToFit];
    [self.view addSubview:navItemright];
    [navItemright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44/2+20-(CGHeight(navItemright.frame)+20)/2);
        make.right.equalTo(self.view.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(CGWidth(navItemright.frame)+20, CGHeight(navItemright.frame)+20));
    }];
}

#pragma -mark 数据
-(void)userData{
    if (_isOfOthers==YES) {
        [MiYiUserRequest userInfoId:_uid json:^(id json) {
           user = [MiYiAccount objectWithKeyValues:json[@"data"][@"user"]];
            [viewUser userData:user];
            [tableViewUser reloadData];
        } error:^(NSError *error) {
        
        }];
    }else{
        [viewUser userData:user];
    }
    [MiYiPostsRequest topicListUserUid:_uid topic_page:@"1" json:^(id json) {
        NSArray *modelArray =[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:json[@"data"][@"forum"]];
        if (modelArray.count ==0) {
            [tableViewUser.footer endRefreshing];
            return ;
        }
        [arrayActivity addObjectsFromArray:modelArray];
        [tableViewUser reloadData];
    } error:^(NSError *error) {
        
    }];
    
    [MiYiWardrobeRequest wardrobeList:_uid page:@"1" blockJson:^(id json) {
        NSArray *modelArray =[MiYiRecommendModel objectArrayWithKeyValuesArray:json[@"data"][@"like"]];
        [arrayWardrobe addObjectsFromArray:modelArray];
        [tableViewUser reloadData];
    } blockError:^(NSError *error) {
        
    }];

    
}



#pragma  -Mark  push

-(void)clickEdit
{
    MiYiInformationModificationVC *vc =[[MiYiInformationModificationVC alloc]init];
    vc.popBlock=^{
        user =[[MiYiUser shared]accountUser];
        [viewUser userData:user];
    };
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma  -mark UITableViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < 0) {
        [viewUser.imageBG mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(viewUser).insets(UIEdgeInsetsMake(yOffset,yOffset,4,yOffset));
        }];
    }else{
        [viewUser.imageBG mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(viewUser).insets(UIEdgeInsetsMake(0, 0, 4, 0));
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        MiYiUserStyleCell*cell=[MiYiUserStyleCell cellWithTableView:tableView identifier:@"MiYiUserStyleCell"];
        cell.userAccount=user;
        cell.delegate=self;
        cell.isOfOthers=_isOfOthers;
        cell.viewController=self;
        cell.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
        return cell;
    }else if(indexPath.row ==1){
        
        MiYiUserActivityCell *cell =[MiYiUserActivityCell cellWithTableView:tableView identifier:@"MiYiUserActivityCell"];
        if (arrayActivity.count!=0) {
            cell.activityModel=arrayActivity[0];
        }else{
            cell.activityModel=nil;
        }
        cell.isOfOthers=_isOfOthers;
        cell.viewController=self;
        cell.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
        return cell;
    }
    MiYiUserWardrobeCell *cell =[MiYiUserWardrobeCell cellWithTableView:tableView identifier:@"MiYiUserWardrobeCell"];
    cell.uid=_uid;
    cell.arrayWardrobe=arrayWardrobe;
    cell.isOfOthers=_isOfOthers;
    cell.viewController=self;
    cell.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CGFloat H =[MiYiUserStyleCell styleHeight:user.style];
        return H +43+15+15+4;
    }else if (indexPath.row==1){
        return 10+15+15+45+15+4;
    }
    return 10+15+15+14+(kWindowWidth-30-20)/3+4;
}

-(void)stylePopBlockReloadData{
    user =[[MiYiUser shared]accountUser];
    [tableViewUser reloadData];
}

#pragma  -mark init
-(UITableView *)getTableViewUser{
    UITableView *table =[UITableView new];
    table.dataSource=self;
    table.delegate=self;
    table.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    table.tableFooterView=[[UIView alloc]init];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return table;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hiddenNavigationBarWhenViewWillAppear = YES;
    }
    return self;
}
@end
