//
//  MiYiHomeVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiHomeVC.h"
#import "CycleScrollView.h"
#import "MiYiWaterflowLayout.h"
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <SDWebImageManager.h>
#import "MiYiModificationNameVC.h"
#import "UIImage+MiYi.h"
#import "MiYiUser.h"
#import "MiYiPostsRequest.h"
#import <MJRefresh.h>
#import "MiYiLoginVC.h"
#import "MiYiNavViewController.h"
#import "MiYiRequestManager.h"
#import "AJLocationManager.h"
#import "MiYiLocationCell.h"
#import <MJExtension.h>
#import "UIImageView+XXImageAnimated.h"
#import "MiYiBaseCommunityModel.h"
#import "MiYiWaterflowHomeCell.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiCommunityPostDetailsVC.h"
static const NSInteger kTotalPageCount = 4;
@interface MiYiHomeVC () <UICollectionViewDataSource, UICollectionViewDelegate, MiYiWaterflowLayoutDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;//数据

@property (nonatomic ,strong) CycleScrollView *mainScorllView;//轮播

@property (nonatomic ,strong) MiYiLoginVC *rootViewControl;//登录

@property (nonatomic, strong) NSMutableArray *viewsArray;//轮播图片存放的imageView控件

@property (nonatomic ,strong) NSString *celsius;//天气文本

@property (nonatomic ,strong) NSString *weatherIn;//天气文本

@property (nonatomic ,strong) UIActivityIndicatorView *activityIndlcator;//香喷喷的菊花

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,strong) NSMutableArray *modelArrayOlder;
@end

@implementation MiYiHomeVC
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
         _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
static NSString *const ID = @"homeCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _modelArrayOlder=[NSMutableArray array];
    
    self.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    [Notification addObserver:self selector:@selector(stopSlideNotification) name:MiYiHomeVCStopSlide object:nil];
    [Notification addObserver:self selector:@selector(navItem) name:MiYiHomeVCNavItemNotification object:nil];
    [Notification addObserver:self selector:@selector(clickLike:) name:@"is_like" object:nil];
    [self navItem];
    [self initUI];
}

#pragma -Mark 通知  点击
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
    [_collectionView reloadData];
}

/**
 *  点击延迟
 */
-(void)suerView{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(suerViewClick) object:nil];
    [self performSelector:@selector(suerViewClick) withObject:nil afterDelay:0.2f];
}
-(void)suerViewClick{
    if(![[MiYiUser shared]accountUser]){
        MiYiLoginVC *rootViewControl = [[MiYiLoginVC alloc] init];
        rootViewControl.isWindow=YES;
        MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:rootViewControl];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(itemdismissClick)];
        
        rootViewControl.navigationItem.leftBarButtonItem=leftItem;
        _rootViewControl=rootViewControl;
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
}
-(void)itemdismissClick{
    [_rootViewControl dismissViewControllerAnimated:YES completion:nil];
}

-(void)itemBtnClick{
    
    [Notification postNotificationName:MiYiSideslipVCSideslipNotification object:nil];
}

-(void)stopSlideNotification{
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
}

#pragma -Mark 初始化
-(void)navItem
{
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_logo"]];
    self.navigationItem.titleView =image;
    UIButton *itemBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn setImage:[UIImage imageNamed:@"home_personalcenter"] forState:UIControlStateNormal];
    if (![[MiYiUser shared]accountUser]) {
        [itemBtn setTitle:@" 未登录" forState:UIControlStateNormal];
        itemBtn.titleLabel.font=Font(15);
        [itemBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(suerView) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn sizeToFit];
    }else
    {
        [itemBtn setImage:[UIImage imageNamed:@"home_personalcenter"] forState:UIControlStateNormal];
        itemBtn.imageView.contentMode=UIViewContentModeScaleAspectFill;
        if ([MiYiUser shared].accountUser.avatar.length!=0) {
            [itemBtn.imageView sd_setImageWithURL:[NSURL URLWithString:[MiYiUser shared].accountUser.avatar] placeholderImage:[UIImage imageNamed:@"home_personalcenter"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [itemBtn setImage:image forState:UIControlStateNormal];
            }];
        }
        [itemBtn addTarget:self action:@selector(itemBtnClick) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.frame =(CGRect){0,0,25,25};
        itemBtn.layer.masksToBounds=YES;
        itemBtn.layer.cornerRadius=25/2;
    }
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)initUI{
    NSMutableArray *viewsArray = [NSMutableArray array];
    _viewsArray=viewsArray;
    
    _mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight >568?130 :110) animationDuration:3];
    
    for (int i = 0; i < kTotalPageCount; ++i) {
        UIImageView *tempLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight >568?130 :110)];
        [_viewsArray addObject:tempLabel];
    }

    self.collectionView =[self getCollectionView];
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:_mainScorllView];

    self.collectionView.header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.collectionView.footer.automaticallyHidden=YES;
    //忽略多少bottominset
    self.collectionView.footer.ignoredScrollViewContentInsetBottom=-80;
    [self.collectionView.header beginRefreshing];
}

#pragma -Mark 刷新
-(void)headerRefresh{
    WS(ws)
    [MiYiPostsRequest topicListTopicHomePage:@"1" json:^(id json) {
        _page=1;
        _modelArrayOlder =json[@"data"][@"home"];
        NSArray *modelArray=[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:json[@"data"][@"home"]];
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        NSMutableArray *dataArrayRefresh =[NSMutableArray array];
        [dataArrayRefresh addObjectsFromArray:array];
        [dataArrayRefresh addObjectsFromArray:ws.dataArray];
        [ws.dataArray removeAllObjects];
        [ws.dataArray addObjectsFromArray:dataArrayRefresh];
        [ws.collectionView reloadData];
        [ws location];
        [ws.collectionView.header endRefreshing];
    } error:^(NSError *error) {
        [ws.collectionView.header endRefreshing];
    }];
#warning 下面还没搞
    __weak MiYiHomeVC *weakSelf =self;
    NSArray *colorArray = @[[UIImage imageNamed:@"image5.jpg"],[UIImage imageNamed:@"image6.jpg"],[UIImage imageNamed:@"image7.jpg"],[UIImage imageNamed:@"image8.jpg"],];
    for (int i = 0; i < kTotalPageCount; ++i) {
        UIImageView  *tempLabel= _viewsArray[i];
        tempLabel.image =[colorArray objectAtIndex:i];
    }
    //数据源：获取总的page个数，如果少于2个，不自动滚动
    _mainScorllView.totalPagesCount = ^NSInteger(void){
        return weakSelf.viewsArray.count;
    };
    //数据源：获取第pageIndex个位置的contentView（这个必须调）
    _mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return weakSelf.viewsArray[pageIndex];
    };
    //当点击的时候，执行的block
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
    };
    
}

-(void)footerRefresh{
    WS(ws)
    [MiYiPostsRequest topicListTopicHomePage:[NSString stringWithFormat:@"%ld",(long)_page+1] json:^(id json) {
        NSArray *modelArray =[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:json[@"data"][@"home"]];
        if (modelArray.count ==0) {
            [MBProgressHUD showError:@"没有更多的数据了"];
            [_collectionView.footer endRefreshing];
            return ;
        }
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        [ws.dataArray addObjectsFromArray:array];
        [ws.collectionView reloadData];
        ++_page;
        [ws.collectionView.footer endRefreshing];
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"网络出现问题"];
        [ws.collectionView.footer endRefreshing];
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


#pragma mark - <LayoutDelegate>


- (CGFloat)waterflowLayout:(MiYiWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]) {
        return  40;
    }else{
        MiYiBaseCommunityModel *model =self.dataArray[indexPath.row-1];
        MiYiPostsImageSModel *imageModel =[MiYiPostsImageSModel objectWithKeyValues:model.images[0]];
        NSRange range = [imageModel.size rangeOfString:@","];
        CGFloat imageH =[[NSString stringWithFormat:@"%@",[imageModel.size substringFromIndex:range.location+1]] floatValue];
        CGFloat imageW =[[NSString stringWithFormat:@"%@",[imageModel.size substringToIndex:range.location]] floatValue];
        CGFloat ratio =imageW /imageH;
        CGFloat H =((kWindowWidth-3)/2)/ratio;

        
        for (int i=0; i < imageModel.tags.count ; i++) {
            if (i>2) {
                break;
            }
            MiYiPostsImageTagIdsModel *tagModel =[MiYiPostsImageTagIdsModel objectWithKeyValues:imageModel.tags[i]];
            if (tagModel.tag_content.length==0) {
                return H+67-23;
                break;
            }
            
          
        }
        return H+67;
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]) {
        //默认新闻提示cell
        MiYiLocationCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"MiYiLocationCell" forIndexPath:indexPath];
        _activityIndlcator=cell.activitylndlcator;
        if (_weatherIn ==nil && _celsius ==nil) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            _celsius =[userDefaults valueForKey:@"weather"];
            _weatherIn =[userDefaults valueForKey:@"description"];
        }
        cell.celsius.text=_celsius;
        cell.weatherIn.text=_weatherIn;
        cell.backgroundColor=[UIColor whiteColor];
        if (self.dataArray.count>=1) {
            cell.hidden=NO;
        }else
        cell.hidden=YES;
        return cell;
    }
    
    MiYiWaterflowHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.homeModel=self.dataArray[indexPath.row-1];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0){
        if([_celsius isEqualToString:@"呜呜~获取天气失败"]){
            [_activityIndlcator stopAnimating];
            _activityIndlcator.hidden=YES;
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"现在去打开定位吧" message:nil delegate:self cancelButtonTitle:@"打开"otherButtonTitles:@"取消" , nil];
            alert.tag=2;
            [alert show];
            }
        }
        [self location];
        return;
    }
    MiYiCommunityPostDetailsVC *vc =[[MiYiCommunityPostDetailsVC alloc]init];
    vc.model=self.dataArray[indexPath.row-1];
    vc.isSelectImage=YES;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}



-(void)location{
    WS(ws)
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        [_activityIndlcator stopAnimating];
        _activityIndlcator.hidden=YES;
        _celsius=@"呜呜~获取天气失败";
        _weatherIn=@"请打开定位吧";
        [ws.collectionView reloadData];
    }else{
        _activityIndlcator.hidden=NO;
        [_activityIndlcator startAnimating];
        [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            MiYiAccount *account=[[MiYiUser shared]accountUser];
            account.location =[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
            [[MiYiUser shared] saveAccountUser:account];
            
            NSString *url =[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&lang=zh_cn&units=metric&APPID=bdffb297230c51f901c19eddc10bafd8",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
            [MiYiRequestManager getWithURL:url params:nil success:^(id json) {
                ws.celsius=[NSString stringWithFormat:@"%@℃",json[@"main"][@"temp"]];
                NSArray *array =json[@"weather"];
                ws.weatherIn=array[0][@"description"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:ws.celsius forKey:@"weather"];
                [userDefaults setObject:ws.weatherIn forKey:@"description"];
                [userDefaults synchronize];
                [ws.activityIndlcator stopAnimating];
                ws.activityIndlcator.hidden=YES;
                ws.dataArray=[MiYiBaseCommunityModel objectArrayWithKeyValuesArray:ws.modelArrayOlder];
                [ws.collectionView reloadData];
            } failure:^(NSError *error) {
                [ws.activityIndlcator stopAnimating];
                ws.activityIndlcator.hidden=YES;
                ws.celsius=@"呜呜~获取天气失败";
                ws.weatherIn=@"请打开定位吧";
                [ws.collectionView reloadData];
            }];
            
        }error:^(NSError *error) {
            [ws.activityIndlcator stopAnimating];
            ws.activityIndlcator.hidden=YES;
            ws.celsius=@"呜呜~获取天气失败";
            ws.weatherIn=@"请打开定位吧";
            [ws.collectionView reloadData];
        }];

        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
    if (alertView.tag==1) {
        if (buttonIndex==0) {
            [self location];
            
        }
    }else if (alertView.tag==2)
    {
        NSLog(@"%ld",(long)buttonIndex);
        if (buttonIndex ==0) {
            [[UIApplication sharedApplication] openURL:[NSURL
                                                        URLWithString:UIApplicationOpenSettingsURLString]];
        }else
        {
            
        }
        
    }
    
    
}



-(UICollectionView *)getCollectionView{
    MiYiWaterflowLayout *layout = [[MiYiWaterflowLayout alloc] init];
    layout.MiYidelegate = self;
    layout.columnsCount = 2;
    layout.sectionInset = UIEdgeInsetsMake(kWindowHeight >568?130 :110, 0, 130, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    [collectionView registerClass:[MiYiWaterflowHomeCell class] forCellWithReuseIdentifier:ID];
    [collectionView registerNib:[UINib nibWithNibName:@"MiYiLocationCell" bundle:nil] forCellWithReuseIdentifier:@"MiYiLocationCell"];
    return collectionView;
}
@end
