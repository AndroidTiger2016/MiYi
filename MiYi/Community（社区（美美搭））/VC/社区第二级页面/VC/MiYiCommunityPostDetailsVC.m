//
//  MiYiCommunityPostDetailsVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/19.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiCommunityPostDetailsVC.h"
#import "MiYiBaseCommunityCell.h"
#import "MiYiCommentsPostDetailCell.h"
#import "MiYiPostsRequest.h"
#import <MJExtension.h>
#import "MBProgressHUD+YXL.h"
#import <MJRefresh.h>
#import "MiYiPhotosView.h"
#import "MiYiRecommendClothesView.h"
#import "MiYiRecommendModel.h"
#import "MiYiPostReviewVC.h"
@interface MiYiCommunityPostDetailsVC ()<UITableViewDataSource,UITableViewDelegate,MiYiBaseCommunityDelegate,MiYiCommentsPostDetailDelegate>
{
    NSInteger tableViewDataSourceNumber;
    MiYiRecommendClothesView *clothesView;
}
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@end

@implementation MiYiCommunityPostDetailsVC


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"详情";
    tableViewDataSourceNumber=1;
    _dataArray = [NSMutableArray array];
    UITableView *tableView = [self getTableView];
    _tableView=tableView;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    [self commentsRefresh];

    if (_model.topic_type ==nil) {
        return;
    }
    if ([_model.topic_type isEqualToString:@"FND"]) {
        if(_model.recommend.length==0){
            return;
        }
        clothesView = [self getClothesView];
        clothesView.topic_type=_model.topic_type;
        CGSize size =[MiYiRecommendClothesView photosViewSizeWithPhotosCount:6];
        clothesView.frame=(CGRect){0,7.5,kWindowWidth, size.height+44};
        UIView *tableFooterViewBackground =[UIView new];
        tableFooterViewBackground.frame=(CGRect){0,0,kWindowWidth,size.height+44+7.5};
        [tableFooterViewBackground addSubview:clothesView];
        tableView.tableFooterView=tableFooterViewBackground;
        [self recommendClothesViewRefresh];
    }
}
-(void)recommendClothesViewRefresh{
    [MiYiPostsRequest recommend:_model.recommend json:^(id json) {
        clothesView.photos=[ MiYiRecommendModel objectArrayWithKeyValuesArray:json[@"data"][@"recommend"]];
    } error:^(NSError *error) {
        
    }];
}

-(void)commentsRefresh{
    WS(ws)
    [MiYiPostsRequest getReviewsTopicUserUid:_model.topic_id topic_page:[NSString stringWithFormat:@"%ld",(long)_page] json:^(id json) {
        NSArray *modelArray =[MiYiPostDatailsModel objectArrayWithKeyValuesArray:json[@"data"][@"comment"]];
        if (modelArray.count ==0) {
            return ;
        }
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        [ws.dataArray addObjectsFromArray:array];
        [ws.tableView reloadData];
        ++_page;
    } error:^(NSError *error) {
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
            MiYiPostDatailsModel *model = theProvisional[a];
            for (int p = 0; p < olderData.count; p++){
                MiYiPostDatailsModel *st = olderData[p];
                if ([model.comment_id  isEqualToString:st.comment_id]) {
                    [self.dataArray removeObject:st];
                }
            }
        }
        [array addObjectsFromArray:theProvisional];
    }else{
        [array addObjectsFromArray:theProvisional];
    }
}
#pragma  -Mark tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count >3) {
        return 1+3+tableViewDataSourceNumber;
    }
    return 1+self.dataArray.count+tableViewDataSourceNumber;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        MiYiBaseCommunityCell*communityCell = [MiYiBaseCommunityCell cellWithTableView:tableView identifier:[NSString stringWithFormat:@"MiYiBaseCommunityCell%@",[self class]]];
        communityCell.delegate=self;
        communityCell.isSelectImage=_isSelectImage;
        communityCell.postDetailsModel=_model;
        return communityCell;
    }else{
        static NSString *prompts = @"prompts";
        UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:prompts];
        NSString *promptsText =@"";
        if(self.dataArray.count >= 3){
            if (self.dataArray.count == 3) {
                promptsText=@"快去评论吧";
            }else
                promptsText=[NSString stringWithFormat:@"剩余%ld条评论,看去查看吧~",(long)self.dataArray.count-3];
        }else{
            if (self.dataArray.count ==0) {
                promptsText=@"现在还没有人评论,快来占领吧";
            }else{
                promptsText=@"评论好少哦,快来评论吧";
            }
        }
        if (indexPath.row ==(1+(self.dataArray.count > 3?3:self.dataArray.count)+tableViewDataSourceNumber)-1) {
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:prompts];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

                UIImageView *imageView =[UIImageView new];
                imageView.image =[UIImage imageNamed:@"ArrowIcon"];
                imageView.frame=(CGRect){{0,0},imageView.image.size};
                UIView *accesoryImageView =[UIView new];
                CGSize size =[promptsText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(12),NSFontAttributeName, nil]];
                CGFloat accesoryW =(kWindowWidth/2-size.width/2)-6;
                accesoryImageView.frame=(CGRect){0,0,accesoryW,imageView.image.size.height};
                [accesoryImageView addSubview:imageView];
                cell.accessoryView=accesoryImageView;
                
            }
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=promptsText;
            cell.textLabel.font=Font(12);
            cell.textLabel.textColor=UIColorFromRGB_HEX(0x585858);
            cell.textLabel.textAlignment=NSTextAlignmentRight;
            cell.layer.borderWidth=0.5;
            cell.layer.borderColor=HEX_COLOR_VIEW_BACKGROUND.CGColor;
            return cell;
        }else{
            MiYiCommentsPostDetailCell *postDetailCell =[MiYiCommentsPostDetailCell cellWithTableView:tableView identifier:[NSString stringWithFormat:@"%@",[self class]]];
            postDetailCell.delegate=self;
            postDetailCell.postDatailsModel=self.dataArray[indexPath.row-1];
            return postDetailCell;
        }
        
    }
}

-(void)tableView:(  UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==(1+(self.dataArray.count > 3?3:self.dataArray.count)+tableViewDataSourceNumber)-1) {
        WS(ws)
        MiYiPostReviewVC *vc =[[MiYiPostReviewVC alloc]init];
        vc.dataArray=self.dataArray;
        vc.model=_model;
        vc.popBlock=^{
            [ws.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        if (!_isSelectImage) {
            return 108+(kWindowWidth-12)+_model.cellTextHeight;
        }
        return 108+(kWindowWidth-12)+70+_model.cellTextHeight;
    }else if (indexPath.row ==(1+(self.dataArray.count > 3?3:self.dataArray.count)+tableViewDataSourceNumber)-1){
        return 48;
    }else{
        MiYiPostDatailsModel *postDatails = self.dataArray[indexPath.row-1];
        for (int i =0; i < postDatails.images.count; i++) {
            MiYiPostsImageSModel *model =[MiYiPostsImageSModel objectWithKeyValues:postDatails.images[i]];
            if (model.img_url==nil) {
                return 73+postDatails.cellTextHeight;
            }
        }
        CGSize size =[MiYiPhotosView photosViewSizeWithPhotosCount:postDatails.images.count];
        return 73+postDatails.cellTextHeight+size.height;
    }
}

#pragma -mark click

-(void)pushUserVC:(id)obj{
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma -Mark pop回调

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_popBlock) {
        _popBlock();
    }
}
#pragma -Mark init
-(UITableView *)getTableView{
    UITableView *table =[[UITableView alloc]init];
    table.delegate=self;
    table.dataSource=self;
    table.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    table.tableFooterView=[[UIView alloc]init];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return table;
}

-(MiYiRecommendClothesView *)getClothesView{
    MiYiRecommendClothesView *view =[MiYiRecommendClothesView new];
    view.backgroundColor=[UIColor whiteColor];
    view.viewController=self;
    return view;
}
-(void)dealloc
{
}
/*
 [MiYiPostsRequest recommend:_model.recommend json:^(id json) {
 NSArray *array =[MiYiRecommendModel objectArrayWithKeyValuesArray:json[@"data"][@"recommend"]];
 weakSelf.recommendClothesView.photos=array;
 } error:^(NSError *error) {
 
 }];
 */
@end
