//
//  MiYiCommunityFour.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/7.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiCommunityFour.h"
#import "MiYiCommunityFourCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "MiYiPostsRequest.h"
#import "MiYiBaseCommunityModel.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiCommunityPostDetailsVC.h"
@interface MiYiCommunityFour ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic ,assign) int page;

@end

@implementation MiYiCommunityFour

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    [self initUI];


}
-(void)initUI
{
    UITableView *tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-64-40}];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.rowHeight=70;
    _tableView=tableView;

    UIView *headerView =[[UIView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,160}];
    UIImageView *image =[[UIImageView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,160}];
    image.image=[UIImage imageNamed:@"bg"];
    [self.view addSubview:tableView];
    [headerView addSubview:image];
    tableView.tableHeaderView=headerView;
    tableView.tableFooterView= [[UIView alloc] init];
    

    
    tableView.header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    tableView.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    tableView.footer.automaticallyHidden=NO;
    [tableView.header beginRefreshing];
   
}

-(void)headerRefresh
{
    __weak MiYiCommunityFour *weakSelf=self;
    [MiYiPostsRequest topicListTopic:MiYiTopic_FAQ topic_page:@"1"  json:^(id json) {
        _page=1;
        NSArray *modelArray =[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:json[@"data"][@"forum"]];
        NSMutableArray *array =[NSMutableArray array];
        [weakSelf traverseData:array newData:modelArray olderData:weakSelf.dataArray];
        NSMutableArray *dataArrayRefresh =[NSMutableArray array];
        [dataArrayRefresh addObjectsFromArray:array];
        [dataArrayRefresh addObjectsFromArray:weakSelf.dataArray];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:dataArrayRefresh];
        
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        
    } error:^(NSError *error) {
       [_tableView.header endRefreshing];
    }];
    
}

-(void)footerRefresh
{
    
    __weak MiYiCommunityFour *weakSelf =self;
    [MiYiPostsRequest topicListTopic:MiYiTopic_FAQ topic_page:[NSString stringWithFormat:@"%d",_page+1] json:^(id json) {
        
        NSLog(@"%@",json);
        NSArray *modelArray =[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:json[@"data"][@"forum"]];
        if (modelArray.count ==0) {
            [MBProgressHUD showError:@"没有更多的数据了"];
            [_tableView.footer endRefreshing];
            return ;
        }
        NSMutableArray *array =[NSMutableArray array];
        [weakSelf traverseData:array newData:modelArray olderData:weakSelf.dataArray];

        [weakSelf.dataArray addObjectsFromArray:array];
        [_tableView reloadData];
        ++_page;
        [_tableView.footer endRefreshing];
        
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"网络出现问题"];
        [_tableView.footer endRefreshing];
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
#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MiYiCommunityFourCell *cell =[MiYiCommunityFourCell cellWithTableView:tableView];
    cell.postDetailsModel = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170/2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MiYiCommunityPostDetailsVC *vc =[[MiYiCommunityPostDetailsVC alloc]init];
    vc.model=self.dataArray[indexPath.row];
    vc.isSelectImage=YES;
    WS(ws)
    vc.popBlock=^{
        [ws.tableView reloadData];
    };
    vc.hidesBottomBarWhenPushed=YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
