//
//  MiYiCommunityOne.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/7.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiCommunityOne.h"
#import "MiYiPostsRequest.h"
#import "MiYiBaseCommunityModel.h"
#import "MiYiCommunityPostDetailsVC.h"
#import "MiYiUserVC.h"
@implementation MiYiCommunityOne


- (void)viewDidLoad {
    [super viewDidLoad];

}

-(MiYiTopic_type)miyiTopic
{
    return MiYiTopic_SHW;
}

-(void)selectRowAtIndexPath:(MiYiBaseCommunityModel *)model
{
    MiYiCommunityPostDetailsVC *vc =[[MiYiCommunityPostDetailsVC alloc]init];
    vc.model=model;
    vc.isSelectImage=YES;
    WS(ws)
    vc.popBlock=^{
        [ws.tableView reloadData];
    };
    vc.hidesBottomBarWhenPushed=YES;
    
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)pushUserVC:(id)obj{
   [self.viewController.navigationController pushViewController:obj animated:YES];
}
@end
