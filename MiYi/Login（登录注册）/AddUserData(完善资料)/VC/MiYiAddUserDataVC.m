//
//  MiYiAddUserDataVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/10/8.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiAddUserDataVC.h"
#import "MiYiAddUserDataCell.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiUserRequest.h"
#import "MiYiUser.h"
@interface MiYiAddUserDataVC ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIImageView *imageProgress;
    UILabel *labelTitle;
    UIButton *buttonNext;
    UICollectionViewFlowLayout *layout;
    NSInteger intNext;
    NSMutableArray *dataArray;
    NSMutableArray *titlArray;
    NSMutableArray *selectArray;
    NSMutableArray *addUserDataArray;
    
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger progress;


@end

@implementation MiYiAddUserDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray =[NSMutableArray array];
    titlArray =[NSMutableArray array];
    selectArray =[NSMutableArray array];
    addUserDataArray =[NSMutableArray array];
    
    intNext=0;
    
    self.title=@"完善我的资料";
    self.view.backgroundColor=[UIColor whiteColor];
    [self initUI];
    // Do any additional setup after loading the view.
}

-(void)initUI{
    imageProgress = [UIImageView new];
    imageProgress.image=[UIImage imageNamed:@"Personal_style"];
    imageProgress.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageProgress];
    [imageProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(kWindowWidth==320?50:60));
    }];
    
    labelTitle = [self getLabelTitle];
    labelTitle.text=@"你的日常穿着更接近哪种风格?";
    [self.view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageProgress.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@18);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    buttonNext = [self getButtonNext];
    [buttonNext addTarget:self action:@selector(clickButtonNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNext];
    [buttonNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth-60, 40));
    }];
    
    _collectionView = [self getCollectionView];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
        make.bottom.equalTo(buttonNext.mas_top).offset(-10);
        make.left.equalTo(@15);
        make.width.equalTo(@(kWindowWidth-30));
        
    }];
    
    
    [self data:0];
    
}

-(void)clickButtonNext:(UIButton *)btn{
    
    if (_progress<4) {
        if (selectArray.count >0) {
            [selectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MiYiAddUserDataCell * cell=obj;
                [addUserDataArray addObject:cell.labelTitle.text];

            }];
            [selectArray removeAllObjects];
            if ([btn.titleLabel.text isEqualToString:@"完成"]) {
                NSString *string = [addUserDataArray componentsJoinedByString:@","];
                
                [MiYiUserRequest modifyInformationType:MiYiUserRequest_typeUserStyle Contents:string Success:^(BOOL success) {
                    if(success){
                        MiYiAccount*account=[[MiYiUser shared]accountUser];
                        account.style=string;
                        [[MiYiUser shared] saveAccountUser:account];
                        _popBlock();
                        return ;
                    }else{
                        [MBProgressHUD showError:@"提交失败"];
                    }
                    
                }];
                return;
            }
            
            
            NSArray *array =[_collectionView visibleCells];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MiYiAddUserDataCell *cell =(MiYiAddUserDataCell *)obj;
                cell.photoSelect=NO;
            }];
            [self data:_progress+1];
        }else{
            [MBProgressHUD showError:@"请选择"];
        }
        [_collectionView reloadData];
    }
    
}





-(void)data:(NSInteger)progress{
    _progress=progress;
    if (progress==0) {
        CGFloat W  =  (kWindowWidth-20-40)/3;
        layout.itemSize=CGSizeMake(W, W+20);
        NSArray *array =@[@"qingshuStyle",@"sengnvStyle",@"clearStyle",@"JSStyle",@"AmericaStyle",@"retoStyle",@"sportStyle",@"LeisureStyle",@"schoolStyle"];
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:array];
        NSArray *array1 =@[@"轻熟",@"森女系",@"小清新",@"日韩范",@"欧美范",@"复古范",@"运动",@"休闲",@"学院风"];
        [titlArray removeAllObjects];
        [titlArray addObjectsFromArray:array1];
    }else if (progress ==1){
        imageProgress.image=[UIImage imageNamed:@"body"];
        labelTitle.text=@"你更接近哪种身材呢?";
        CGFloat W  =  (kWindowWidth-20-120)/2;
        layout.itemSize=CGSizeMake(W, W+20);
        layout.sectionInset = UIEdgeInsetsMake(50, 30, 50, 30);
        NSArray *array =@[@"appleBody",@"pearBody",@"bananaBody",@"hourglassBody"];
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:array];
        NSArray *array1 =@[@"苹果型",@"梨型",@"香蕉型",@"沙漏型"];
        [titlArray removeAllObjects];
        [titlArray addObjectsFromArray:array1];
    }else if (progress ==2){
        imageProgress.image=[UIImage imageNamed:@"skin"];
        labelTitle.text=@"你的肤色更接近于以下哪种?";
        CGFloat W  =  (kWindowWidth-20-120)/2;
        layout.itemSize=CGSizeMake(W, W+20);
        layout.sectionInset = UIEdgeInsetsMake(50, 30, 50, 30);
        NSArray *array =@[@"whiteSkin",@"yellowSkin",@"blackSkin",@"pinkSkin"];
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:array];
        NSArray *array1 =@[@"偏白",@"偏黄",@"偏黑",@"粉嫩"];
        [titlArray removeAllObjects];
        [titlArray addObjectsFromArray:array1];
    }else if (progress ==3){
        [buttonNext setTitle:@"完成" forState:UIControlStateNormal];
        imageProgress.image=[UIImage imageNamed:@"face"];
        labelTitle.text=@"你的脸型更接近于以下哪种?";
        CGFloat W  =  (kWindowWidth-20-40)/3;
        layout.itemSize=CGSizeMake(W, W+20);
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        NSArray *array =@[@"gooseFace",@"squareFace",@"roundFace",@"longFace",@"starFace",@"triangleFace",@"jewelFace"];
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:array];
        NSArray *array1 =@[@"鹅蛋脸",@"方形脸",@"圆形脸",@"长形脸",@"心型脸",@"三角形脸",@"钻石型脸"];
        [titlArray removeAllObjects];
        [titlArray addObjectsFromArray:array1];
    }
    
}

#pragma  -mark delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    MiYiAddUserDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MiYiAddUserDataCell" forIndexPath:indexPath];
    cell.imageContents.image=[UIImage imageNamed:dataArray[indexPath.row]];
    cell.labelTitle.text=titlArray[indexPath.row];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_progress==0) {
            MiYiAddUserDataCell * cell  = (MiYiAddUserDataCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if(cell.photoSelect == YES){
                cell.photoSelect=NO;
                [selectArray removeObject:cell];
            }else{
                cell.photoSelect=YES;
                [selectArray addObject:cell];
            }
    }else {

        if (selectArray.count>0) {
            MiYiAddUserDataCell * cell=[selectArray lastObject];
            cell.photoSelect=NO;
            [selectArray removeObject:cell];
        }
        MiYiAddUserDataCell * cell  = (MiYiAddUserDataCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(cell.photoSelect == YES){
            cell.photoSelect=NO;
            [selectArray removeObject:cell];
        }else{
            cell.photoSelect=YES;
            [selectArray addObject:cell];
        }
    }
    
}

#pragma -mark init
-(UILabel *)getLabelTitle{
    UILabel *label =[UILabel new];
    label.font=Font(18);
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    return label;
}

-(UIButton *)getButtonNext{
    UIButton *btn =[UIButton new];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=20;
    btn.layer.borderWidth=1;
    btn.layer.borderColor=HEX_COLOR_THEME.CGColor;
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:HEX_COLOR_THEME forState:UIControlStateNormal];
    return btn;
}

-(UICollectionView *)getCollectionView{
    layout =[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.alwaysBounceVertical=YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[MiYiAddUserDataCell class] forCellWithReuseIdentifier:@"MiYiAddUserDataCell"];
    return collectionView;
}

@end
