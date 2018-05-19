//
//  MiYiFansVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/16.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiFansVC.h"
#import "MiYiConcernedWithTheFansRequest.h"
#import "MiYiOwnerModel.h"
#import <MJExtension.h>
#import "MiYiFansCell.h"
#import <MJRefresh.h>
#import "MBProgressHUD+YXL.h"
@interface MiYiFansVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic ,weak) UITableView *tableView;

@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,weak) UILabel *promptLabel;
@end

@implementation MiYiFansVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    
    UITableView *tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-40-64} style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.rowHeight=50;
    [self.view addSubview:tableView];
    _tableView=tableView;
    tableView.tableFooterView=[[UIView alloc]init];
    _dataArray =[NSMutableArray array];
    
    
    tableView.header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    tableView.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    tableView.footer.automaticallyHidden=YES;
    [tableView.header beginRefreshing];
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)headerRefresh
{
    WS(ws)
    [MiYiConcernedWithTheFansRequest concernedWithTheFansFans:@"1" json:^(id json) {
        NSLog(@"%@",json);
        _page=1;
        NSArray *modelArray = [MiYiOwnerModel objectArrayWithKeyValuesArray:json[@"data"][@"follower"]];
        if (modelArray.count==0) {
            NSString *msg=@"";
            if (ws.dataArray.count==0) {
                msg=@"还没有人关注你";
            }else
            {
                [MBProgressHUD showError:@"没有新的粉丝"];
            }

        if (self.promptLabel) {
            self.promptLabel.text = msg;
        }else
        {
            UILabel * label = [[UILabel alloc]initWithFrame:self.view.bounds];
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
            self.promptLabel = label;
            label.text = msg;
        }
            [ws.tableView.header endRefreshing];
        
            return ;
        }
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        NSMutableArray *dataArrayRefresh =[NSMutableArray array];
        [dataArrayRefresh addObjectsFromArray:array];
        [dataArrayRefresh addObjectsFromArray:ws.dataArray];
        [ws.dataArray removeAllObjects];
        [ws.dataArray addObjectsFromArray:dataArrayRefresh];
        [ws.tableView reloadData];
        [ws.tableView.header endRefreshing];
    } error:^(NSError *error) {
        [ws.tableView.header endRefreshing];
        
    }];
}

-(void)footerRefresh
{
    WS(ws)
    [MiYiConcernedWithTheFansRequest concernedWithTheFansFans:[NSString stringWithFormat:@"%ld",(long)_page] json:^(id json) {
        NSLog(@"%@",json);
        
        NSArray *modelArray = [MiYiOwnerModel objectArrayWithKeyValuesArray:json[@"data"][@"following"]];
        if (modelArray.count ==0) {
            [MBProgressHUD showError:@"没有更多的数据了"];
            [ws.tableView.footer endRefreshing];
            return ;
        }
        _page++;
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        [ws.dataArray addObjectsFromArray:array];
        [ws.tableView reloadData];
        [ws.tableView.footer endRefreshing];
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
            MiYiOwnerModel *model = theProvisional[a];
            
            for (int p = 0; p < olderData.count; p++)
            {
                MiYiOwnerModel *st = olderData[p];
                
                if ([model.user_id  isEqualToString:st.user_id]) {
                    [self.dataArray removeObject:st];
                    
                }
            }
        }
        //        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",olderData];
        //
        //        NSArray * filter = [theProvisional filteredArrayUsingPredicate:filterPredicate];
        [array addObjectsFromArray:theProvisional];
        
    }else
    {
        [array addObjectsFromArray:theProvisional];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiFansCell *cell =[MiYiFansCell cellWithTableView:tableView];
    cell.ownerModel=self.dataArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
