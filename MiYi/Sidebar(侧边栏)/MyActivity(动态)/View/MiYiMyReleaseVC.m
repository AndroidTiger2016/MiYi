//
//  MiYiMyReleaseVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/17.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiMyReleaseVC.h"
#import "MiYiPostsRequest.h"
#import "MiYiUserSession.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "MiYiBaseCommunityCell.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiCommunityPostDetailsVC.h"
@interface MiYiMyReleaseVC ()<UITableViewDataSource,UITableViewDelegate,MiYiBaseCommunityDelegate>

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,weak) UILabel *promptLabel;

@end

@implementation MiYiMyReleaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=0;

    UITableView *tableView =[[UITableView alloc]init];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    _tableView=tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(6, 0, _uid.length==0?40+64:0, 0));
    }];
    tableView.tableFooterView=[[UIView alloc]init];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _dataArray=[NSMutableArray array];

    tableView.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [tableView.footer beginRefreshing];
    
    [Notification addObserver:self selector:@selector(clickfollow:) name:@"follow" object:nil];
    [Notification addObserver:self selector:@selector(clickLike:) name:@"is_like" object:nil];

}

/**
 *  更改关注改变
 */
-(void)clickfollow:(NSNotification *)follow
{
    NSLog(@"%@",[self class]);
    NSDictionary *dic = [follow object];
    for (int i=0; i<self.dataArray.count; i++) {
        MiYiBaseCommunityModel *communityModel =self.dataArray[i];
        if ([communityModel.owner.user_id isEqualToString:dic[@"userid"]]) {
            communityModel.is_following =dic[@"is_following"];
        }
    }
    [_tableView reloadData];
    
}
/**
 *  更改收藏改变
 */
-(void)clickLike:(NSNotification *)like
{
    NSDictionary *dic = [like object];
    for (int i=0; i<self.dataArray.count; i++) {
        MiYiBaseCommunityModel *communityModel =self.dataArray[i];
        if ([communityModel.topic_id isEqualToString:dic[@"topic_id"]]) {
            communityModel.is_like =dic[@"is_like"];
            communityModel.like_count=dic[@"like_count"];
        }
    }
    [_tableView reloadData];
}
-(void)footerRefresh{
    WS(ws)
    [MiYiPostsRequest topicListUserUid:_uid topic_page:[NSString stringWithFormat:@"%ld",(long)_page+1] json:^(id json) {
        NSArray *modelArray =[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:json[@"data"][@"forum"]];
        if (_page==0) {
            [MBProgressHUD hideHUD];
            ws.tableView.contentOffset =CGPointMake(0, -6);
            if (modelArray.count ==0) {
                NSString * msg = @"没有发布的帖子~~~";
                if (self.promptLabel) {
                    self.promptLabel.text = msg;
                }else{
                    UILabel * label = [[UILabel alloc]initWithFrame:self.view.bounds];
                    label.backgroundColor = [UIColor whiteColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    [self.view addSubview:label];
                    self.promptLabel = label;
                    label.text = msg;
                }
                [_tableView.footer endRefreshing];
                return ;
            }
        }
        if (modelArray.count ==0) {
            [MBProgressHUD showError:@"没有更多数据了"];
            [_tableView.footer endRefreshing];
            return ;
        }
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        [ws.dataArray addObjectsFromArray:array];
        [ws.tableView reloadData];
        ++_page;
        [_tableView.footer endRefreshing];
 
        NSLog(@"%@",json);
    } error:^(NSError *error) {
        
    }];
}
-(void)traverseData:(NSMutableArray *)array newData:(NSArray *)newDataArray olderData:(NSMutableArray *)olderData
{
    NSMutableArray *theProvisional = [NSMutableArray array];
    [theProvisional addObjectsFromArray:newDataArray];
    if(olderData.count){
        
        for (int a = 0; a < theProvisional.count; a++)
        {
            MiYiBaseCommunityModel *model = theProvisional[a];
            
            for (int p = 0; p < olderData.count; p++)
            {
                MiYiBaseCommunityModel *st = olderData[p];
                
                if ([model.topic_id  isEqualToString:st.topic_id]) {
                    [self.dataArray removeObject:st];
                    
                }
            }
        }

        [array addObjectsFromArray:theProvisional];
        
    }else
    {
        [array addObjectsFromArray:theProvisional];
    }
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiBaseCommunityCell *cell =[MiYiBaseCommunityCell cellWithTableView:tableView identifier:@"MiYiMyReleaseVC"];
    cell.delegate=self;
    cell.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    cell.postDetailsModel=self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiBaseCommunityModel *model =self.dataArray[indexPath.row];
    [self selectRowAtIndexPath:model];
}

-(void)selectRowAtIndexPath:(MiYiBaseCommunityModel *)model
{
    MiYiCommunityPostDetailsVC *vc =[[MiYiCommunityPostDetailsVC alloc]init];
    vc.model=model;
    
    vc.hidesBottomBarWhenPushed=YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiBaseCommunityModel *model =self.dataArray[indexPath.row];
    return 108+(kWindowWidth-12)+model.cellTextHeight +6;
}

-(void)pushUserVC:(id)obj{
    [self.viewController.navigationController pushViewController:obj animated:YES];
}

-(void)dealloc
{
    [Notification removeObserver:self];
}
@end
