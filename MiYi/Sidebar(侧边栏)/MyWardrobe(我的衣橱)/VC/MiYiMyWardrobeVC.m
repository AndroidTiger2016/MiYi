//
//  MiYiMyWardrobeVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/12.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiMyWardrobeVC.h"
#import "MiYiWardrobeRequest.h"
#import "MiYiUserSession.h"
#import "MiYiRecommendModel.h"
#import "MiYiMyWardrobeCell.h"
#import <MJExtension.h>
#import "MiYiProductDetailsVC.h"
#import <MJRefresh.h>
#import "MBProgressHUD+YXL.h"
@interface MiYiMyWardrobeVC ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,weak) UICollectionView *collectionView;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic ,assign) NSInteger page;
@end

@implementation MiYiMyWardrobeVC
static NSString *const ID = @"wardrobe";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];

    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UICollectionView *collectionView =[[UICollectionView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight} collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    [collectionView registerNib:[UINib nibWithNibName:@"MiYiMyWardrobeCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    _collectionView=collectionView;
    
    
    _dataArray=[NSMutableArray array];
    
    
    collectionView.header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    collectionView.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    collectionView.footer.automaticallyHidden=YES;
    [collectionView.header beginRefreshing];
    collectionView.footer.ignoredScrollViewContentInsetBottom=-64;

    
    

}

- (void) headerRefresh
{
    __weak MiYiMyWardrobeVC *weakSelf =self;
    [MiYiWardrobeRequest wardrobeList:_uid page:@"1" blockJson:^(id json) {
        _page=1;
        NSArray *modelArray =[MiYiRecommendModel objectArrayWithKeyValuesArray:json[@"data"][@"like"]];
        NSMutableArray *array =[NSMutableArray array];
        [weakSelf traverseData:array newData:modelArray olderData:weakSelf.dataArray];
        NSMutableArray *dataArrayRefresh =[NSMutableArray array];
        [dataArrayRefresh addObjectsFromArray:array];
        [dataArrayRefresh addObjectsFromArray:weakSelf.dataArray];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:dataArrayRefresh];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.header endRefreshing];
        NSLog(@"%@",json);
    } blockError:^(NSError *error) {
        
    }];
}

- (void) footerRefresh
{
    __weak MiYiMyWardrobeVC *weakSelf =self;
    [MiYiWardrobeRequest wardrobeList:_uid page:[NSString stringWithFormat:@"%ld",(long)_page+1] blockJson:^(id json) {
        _page++;
        NSArray *modelArray =[MiYiRecommendModel objectArrayWithKeyValuesArray:json[@"data"][@"like"]];
        if (modelArray.count ==0) {
            [MBProgressHUD showError:@"没有更多的数据了"];
            [weakSelf.collectionView.footer endRefreshing];
            return ;
        }
        NSMutableArray *array =[NSMutableArray array];
        [weakSelf traverseData:array newData:modelArray olderData:weakSelf.dataArray];
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.footer endRefreshing];

        NSLog(@"%@",json);
    } blockError:^(NSError *error) {
        
    }];
}

-(void)traverseData:(NSMutableArray *)array newData:(NSArray *)newDataArray olderData:(NSMutableArray *)olderData
{
    NSMutableArray *theProvisional = [NSMutableArray array];
    [theProvisional addObjectsFromArray:newDataArray];
    if(olderData.count){
        
        for (int a = 0; a < theProvisional.count; a++)
        {
            MiYiRecommendModel *model = theProvisional[a];
            
            for (int p = 0; p < olderData.count; p++)
            {
                MiYiRecommendModel *st = olderData[p];
                
                if ([model.ID  isEqualToString:st.ID]) {
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



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count ;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (collectionView.bounds.size.width - 5 *4  )/ 2;
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    MiYiMyWardrobeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.model=self.dataArray[indexPath.row];
    //    cell.shop = self.shops[indexPath.row-1];
    cell.layer.masksToBounds=YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiProductDetailsVC *vc =[[MiYiProductDetailsVC alloc]init];
    vc.model=self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"选择%ld",(long)indexPath.row);
    
}


@end
