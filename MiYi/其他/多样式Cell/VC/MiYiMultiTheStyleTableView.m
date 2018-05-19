//
//  MiYiMultiTheStyleTableView.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiMultiTheStyleTableView.h"
#import "MiYiItemGroup.h"
#import "MiYiCellItem.h"
#import "MiYiMultiTheStyleCell.h"
#import "MiYiArrowItem.h"
@interface MiYiMultiTheStyleTableView ()<UITableViewDataSource,UITableViewDelegate>



@end

@implementation MiYiMultiTheStyleTableView

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (MiYiItemGroup *)addGroup
{
    MiYiItemGroup *group = [MiYiItemGroup group];
    [self.groups addObject:group];
    return group;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    _tableView=tableView;
    
    
    self.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%ld",(long)self.groups.count);
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MiYiItemGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiMultiTheStyleCell *cell = [MiYiMultiTheStyleCell cellWithTableView:tableView];
    MiYiItemGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}



#pragma mark - 代理

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    MiYiItemGroup *group = self.groups[section];
    return group.footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MiYiItemGroup *group = self.groups[section];
    return group.header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 1.取出模型
    MiYiItemGroup *group = self.groups[indexPath.section];
    MiYiCellItem *item = group.items[indexPath.row];
    
    // 2.操作
    if (item.operation) {
        item.operation();
    }
    
    // 3.跳转
    if ([item isKindOfClass:[MiYiArrowItem class]]) {
        MiYiArrowItem *arrowItem = (MiYiArrowItem *)item;
        if (arrowItem.destVcClass) {
            UIViewController *destVc = [[arrowItem.destVcClass alloc] init];
            destVc.title = arrowItem.title;
            [self.navigationController pushViewController:destVc animated:YES];
        }
    }
}

-(void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [Notification removeObserver:self];

}
@end
