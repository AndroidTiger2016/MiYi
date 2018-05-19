//
//  MiYiPhotoLibraryViewController.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPhotoLibraryViewController.h"
#import "MiYiAssetManager.h"
#import "MiYiPhotoCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MiYiAssetManager.h"
#import "UIImage+MiYi.h"
#import "MiYiPhotoLibraryHeader.h"
#import "MiYiPhotoGroupListView.h"
#import <AVFoundation/AVFoundation.h>
#import "MiYiCamera.h"
#import "MiYiReleaseVC.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiTabBarViewController.h"
@interface MiYiPhotoLibraryViewController ()<MiYiAssetManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,MiYiCameraDelegate>
{
    NSMutableArray * cameraArray;
}

@property (weak, nonatomic)  UICollectionViewFlowLayout *layout;
@property (weak, nonatomic)  UICollectionView *collectionView;
@property (nonatomic, strong) MiYiGroupAsset * group;
@property (weak, nonatomic)  UILabel *countLabel;
@property (weak, nonatomic) UILabel * promptLabel;

@property (nonatomic, strong) NSArray * previewPhotos;
@property (nonatomic, strong) NSArray * previewThumbs;

@property (nonatomic, weak) MiYiPhotoLibraryHeader * titleHeader;
@property (nonatomic, weak) MiYiPhotoGroupListView * groupListView;

@property (nonatomic, weak) MiYiCamera * picker;

@property (nonatomic ,strong)NSMutableArray * selectArray;
@end

@implementation MiYiPhotoLibraryViewController

-(NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    cameraArray = [NSMutableArray array];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.itemSize = CGSizeMake(50, 50);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 200, 0);
    
    UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-64} collectionViewLayout:layout];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    [self.view addSubview:collectionView];
    _collectionView=collectionView;
    
    UIImage *imageCamera =[UIImage imageNamed:@"camera"];
    UIButton *cameraBtn =[[UIButton alloc]initWithFrame:(CGRect){{kWindowWidth/2-imageCamera.size.height/2,kWindowHeight-64-imageCamera.size.height-50},imageCamera.size}];
    cameraBtn.backgroundColor=[UIColor clearColor];
    [cameraBtn setImage:imageCamera forState:UIControlStateNormal];
    
    [cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    
    [[MiYiAssetManager shareAssetManager]refresh];
    
    UINib * nib = [UINib nibWithNibName:@"MiYiPhotoCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"MiYiPhotoCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    float width = [UIScreen mainScreen].bounds.size.width / 2;
    MiYiPhotoLibraryHeader * header = [[MiYiPhotoLibraryHeader alloc]initWithFrame:CGRectMake(0, 0, width, 44.)];
    self.navigationItem.titleView = header;
    header.title = self.title;
    self.titleHeader = header;
    [header addTarget:self action:@selector(headerValueChange:) forControlEvents:UIControlEventValueChanged];
    [[MiYiAssetManager shareAssetManager]setDelegate:self];
    [[MiYiAssetManager shareAssetManager]refresh];
}

-(void)cameraBtnClick
{
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"Denied");   //不允许的话
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的 设置-隐私-相机中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
            
        }];
        
    }else if(authStatus == AVAuthorizationStatusRestricted)
    {
        NSLog(@"Denied");   //不允许的话
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的 设置-隐私-相机中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
        
    }
    else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        
        MiYiCamera * picker =[[MiYiCamera alloc]init];
        picker.view.backgroundColor=[UIColor blackColor];
        picker.delegate=self;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
        _picker =picker;
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}



-(void)nextBtnClick:(UIButton *)btn
{
    if (![_classString isSubclassOfClass:[MiYiTabBarViewController class]]) {
        _blockSelect(self.selectArray);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        if (self.selectArray.count!=0) {
            MiYiReleaseVC *vc =[[MiYiReleaseVC alloc]init];
            vc.setArray=self.selectArray;
            vc.title=_stringTitle;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [MBProgressHUD showError:@"请选择图片"];
        }
        
    }
    
    
    
    
    
    
}
- (void)backBtnBack
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)setMaxSelectCount:(NSInteger)maxSelectCount
{
    _maxSelectCount=maxSelectCount;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnBack)];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font =Font(15);
    
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_classString isSubclassOfClass:[MiYiTabBarViewController class]]) {
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }else
    {
        [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
        
    }
    [nextBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:nextBtn];
}

- (void)headerValueChange:(MiYiPhotoLibraryHeader *)header
{
    if (self.groupListView) {
        [self.groupListView dismiss];
        self.groupListView = nil;
        [header setOn:NO animated:YES];
    }else
    {
        self.groupListView = [MiYiPhotoGroupListView showToView:self.view block:^(MiYiGroupAsset * group)
                              {
                                  if (group) {
                                      self.group = group;
                                  }else
                                      [header setOn:NO animated:YES];
                              }];
    }
}



- (void)setGroup:(MiYiGroupAsset *)group
{
    if ([_group isEqual:group]) {
        //        return;
    }
    _group = group;
    self.title = [_group.group valueForProperty:ALAssetsGroupPropertyName];
    
    
    [self.collectionView reloadData];
    NSLog(@"3");
    if (self.group.list.count !=0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.group.list.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
    
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleHeader.title = title;
}
#pragma mark -

- (void)assetManagerDidRefresh:(MiYiAssetManager *)manager
{
    if (self.group == nil) {
        for (MiYiGroupAsset * tempGroup in [[MiYiAssetManager shareAssetManager]groupList]) {
            if([[tempGroup.group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos)
            {
                self.group = tempGroup;
                break;
            }
        }
        if (!self.group) {
            self.group = [self.group.list firstObject];
        }
    }else
    {
#warning bug  在系统相册删除选中数组里面的相片后  选中数组未删除，待解决
        for (MiYiGroupAsset * tempGroup in [[MiYiAssetManager shareAssetManager]groupList]) {
            if ( [[tempGroup.group valueForProperty:ALAssetsGroupPropertyURL] isEqual:[self.group.group valueForProperty:ALAssetsGroupPropertyURL] ]) {
                self.group = tempGroup;
                break;
            }
        }
    }
    [self.collectionView reloadData];
    NSLog(@"4");
    //    NSInteger count = self.group.list.count;
    //    if (count != 0) {
    //        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    //        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    //    }
    //    CGPoint offset = CGPointMake(0, self.collectionView.contentSize.height - 1);
    //    [self.collectionView setContentOffset:offset];
}

- (void)assetManager:(MiYiAssetManager *)manager refreshFailedWithError:(NSError *)error
{
    NSString * msg = @"获取照片失败,请设置中修改照片权限";
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
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (collectionView.bounds.size.width - 5 * 5 )/ 4;
    return CGSizeMake(width, width);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.group.list.count;
    if (count == 0 && self.promptLabel) {
        [self.promptLabel removeFromSuperview];
        self.promptLabel = nil;
    }
    count += cameraArray.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MiYiPhotoCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row >= self.group.list.count) {
        UIImage * img = cameraArray[indexPath.row -  self.group.list.count];
        cell.imageView.image = img;
        cell.photoSelect = [self.selectArray containsObject:img];
    }else
    {
        ALAsset * set = self.group.list[indexPath.row];
        
        cell.photoSelect = NO;
        for (ALAsset * tempSet in self.selectArray) {
            if ([tempSet isEqual:set]) {
                cell.photoSelect = YES;
                break;
            }
        }
        
        //        cell.photoSelect = [self.selectArray containsObject:set];
        cell.imageView.image = [UIImage imageWithCGImage:set.thumbnail];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiPhotoCollectionViewCell * cell  = (MiYiPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ALAsset * set = self.group.list[indexPath.row];
    if ([self.selectArray containsObject:set]) {
        [self.selectArray removeObject:set];
        cell.photoSelect = NO;
    }else
    {
        if (self.selectArray.count == self.maxSelectCount) {
            NSString * msg = [NSString stringWithFormat:@"当前最多只允许选择%@张",[NSNumber numberWithInteger:self.maxSelectCount]];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        for (int i=0; i<self.selectArray.count; i++) {
            
            ALAsset * set1 =self.selectArray[i];
            
            if ([set isEqual:set1]) {
                
                [self.selectArray removeObject:set1];
                cell.photoSelect = NO;
                return;
            }else
            {
                
                
            }
            
        }
        
        
        
        
        [self.selectArray addObject:set];
        cell.photoSelect = YES;
    }
    //    self.preViewBtn.enabled = (self.selectArray.count > 0);
    self.countLabel.text = [NSString stringWithFormat:@"%@张",[NSNumber numberWithInteger:[self.selectArray count]]];
}


//#pragma mark - MWPhotoBrowserDelegate
//
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return _previewPhotos.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    if (index < _previewPhotos.count)
//        return [_previewPhotos objectAtIndex:index];
//    return nil;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
//    if (index < _previewThumbs.count)
//        return [_previewThumbs objectAtIndex:index];
//    return nil;
//}

#pragma mark - MiYiCamerDelegate

- (void)cameraImage:(UIImage *)image
{
    
    [[MiYiAssetManager shareAssetManager]addNewImage:image metaData:nil completion:^(ALAsset *set) {
        if (self.selectArray.count == self.maxSelectCount) {
            
            NSLog(@"2");
            NSString * msg = [NSString stringWithFormat:@"当前最多只允许选择%@张",[NSNumber numberWithInteger:self.maxSelectCount]];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            //            [self.collectionView reloadData];
            return;
        }else
        {
            NSLog(@"1");
            [self.selectArray addObject:set];
            self.countLabel.text = [NSString stringWithFormat:@"%@张",[NSNumber numberWithInteger:[self.selectArray count]]];
            //            [self.collectionView reloadData];
            
        }
        
        
    }];
    //    [self.selectArray addObject:image];
    //    [cameraArray addObject:image];
    
    //    self.preViewBtn.enabled = (self.selectArray.count > 0);
}

-(void)dealloc
{
    [Notification removeObserver:self];
}
@end
