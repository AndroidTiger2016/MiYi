//
//  MiYiBaseCommunityVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/2.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseCommunityVC.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "MiYiBaseCommunityModel.h"
#import "MiYiBaseCommunityCell.h"
#import "MiYiPostsRequest.h"
#import <MJExtension.h>
#import "MBProgressHUD+YXL.h"
@interface MiYiBaseCommunityVC ()<UITableViewDelegate,UITableViewDataSource,MiYiBaseCommunityDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,assign) int page;
@end
@implementation MiYiBaseCommunityVC


- (NSMutableArray *) dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        return _dataArray;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    [self initUI];
    // Do any additional setup after loading the view.
}

-(MiYiTopic_type)miyiTopic{
    return MiYiTopic_SHW;
}

-(void)initUI{
    UITableView *tableView =[self getTableView];
    _tableView=tableView;
    [self.view addSubview:_tableView];
    
    _tableView.header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    _tableView.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    _tableView.footer.automaticallyHidden=YES;
    [_tableView.header beginRefreshing];
    
    [Notification addObserver:self selector:@selector(clickfollow:) name:@"follow" object:nil];
    [Notification addObserver:self selector:@selector(clickLike:) name:@"is_like" object:nil];
    
}

#pragma -Mark Notification

/**
 *  更改关注改变
 */
-(void)clickfollow:(NSNotification *)follow{
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
-(void)clickLike:(NSNotification *)like{
    NSDictionary *dic = [like object];
    for (int i=0; i<self.dataArray.count; i++) {
        MiYiBaseCommunityModel *communityModel =self.dataArray[i];
        if ([communityModel.topic_id isEqualToString:dic[@"topic_id"]]) {
            communityModel.is_like =dic[@"is_like"];
            communityModel.like_count=dic[@"like_count"];
        }
    }
    [self.tableView reloadData];
}
#pragma -Mark Refresh

- (void) headerRefresh {
    WS(ws)
    [MiYiPostsRequest topicListTopic:[self miyiTopic] topic_page:@"1"json:^(id json) {
        _page=1;
        NSArray *modelArray =[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:json[@"data"][@"forum"]];
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        NSMutableArray *dataArrayRefresh =[NSMutableArray array];
        [dataArrayRefresh addObjectsFromArray:array];
        [dataArrayRefresh addObjectsFromArray:ws.dataArray];
        [ws.dataArray removeAllObjects];
        [ws.dataArray addObjectsFromArray:dataArrayRefresh];
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    } error:^(NSError *error) {
        [_tableView.header endRefreshing];
    }];
}

- (void) footerRefresh {
    WS(ws)
    [MiYiPostsRequest topicListTopic:[self miyiTopic] topic_page:[NSString stringWithFormat:@"%d",_page+1] json:^(id json) {
        NSArray *modelArray =[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:json[@"data"][@"forum"]];
        if (modelArray.count ==0) {
            [MBProgressHUD showError:@"没有更多的数据了"];
            [_tableView.footer endRefreshing];
            return ;
        }
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        [ws.dataArray addObjectsFromArray:array];
        [_tableView reloadData];
        ++_page;
        [_tableView.footer endRefreshing];
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"网络出现问题"];
        [_tableView.footer endRefreshing];
    }];
}

/**
 *  筛选相同数据
 *
 *  @param array        新数组用于保存筛选后的数据
 *  @param newDataArray 准备筛选的新数据
 *  @param olderData    旧数据
 */
-(void)traverseData:(NSMutableArray *)array newData:(NSArray *)newDataArray olderData:(NSMutableArray *)olderData{
    NSMutableArray *theProvisional = [NSMutableArray array];
    [theProvisional addObjectsFromArray:newDataArray];
    if(olderData.count){
        for (int a = 0; a < theProvisional.count; a++){
            MiYiBaseCommunityModel *model = theProvisional[a];
            for (int p = 0; p < olderData.count; p++){
                MiYiBaseCommunityModel *st = olderData[p];
                if ([model.topic_id  isEqualToString:st.topic_id]) {
                    [self.dataArray removeObject:st];
                }
            }
        }
        [array addObjectsFromArray:theProvisional];
    }else{
        [array addObjectsFromArray:theProvisional];
    }
}
#pragma -Mark tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MiYiBaseCommunityCell *cell =[MiYiBaseCommunityCell cellWithTableView:tableView identifier:[NSString stringWithFormat:@"%@",[self class]]];
    cell.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    cell.viewController=self;
    cell.delegate=self;
    cell.postDetailsModel=self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MiYiBaseCommunityModel *model =self.dataArray[indexPath.row];
    [self selectRowAtIndexPath:model];
}

-(void)pushUserVC:(id)obj{
    
}

-(void)selectRowAtIndexPath:(MiYiBaseCommunityModel *)model{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MiYiBaseCommunityModel *model =self.dataArray[indexPath.row];
    return 108+(kWindowWidth-12)+model.cellTextHeight +6;
}


#pragma -Mark init
-(UITableView *)getTableView{
    UITableView *tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-22-40-50}];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    tableView.tableFooterView=[[UIView alloc]init];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.contentInset=UIEdgeInsetsMake(6, 0, 0, 0);
    return tableView;
}
@end
