//
//  MiYiUnitedStatesTakeShowVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/29.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiReleaseVC.h"
#import "MiYiTabBarButton.h"
#import "UIImage+MiYi.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "MiYiBoxSelectedVC.h"
#import "MiYiDynamicScrollView.h"
#import "MiYiTagsVC.h"
#import "MiYiTagView.h"
#import "MiYiOwnerModel.h"
#import <MJExtension.h>
#import "MiYiSentVC.h"
#import "MiYiMenuSentModel.h"
#import "MiYiTagEditorImageView.h"
@interface MiYiReleaseVC ()

@property (nonatomic ,strong) NSMutableArray *imageArray;

@property (nonatomic ,strong) UIImage *firstPhoto;

@property (nonatomic ,weak) MiYiTagEditorImageView *imageView;

@property (nonatomic ,strong) NSMutableArray *tagsArray;

@property (nonatomic ,assign) CGFloat proportion;

@property (nonatomic ,strong) NSMutableArray *tagArray;

@property (nonatomic ,strong) NSMutableArray *boundsArray;

@property (nonatomic ,weak) MiYiDynamicScrollView *dynamicScrollView;

@property (nonatomic ,strong) MiYiMenuSentModel *model;

@property (nonatomic ,assign) int tagInt;
@end

@implementation MiYiReleaseVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self unitedStatesTakeShowUI];
    
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;
  
    
}
//压缩图片
- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.5);
}

-(void)unitedStatesTakeShowUI
{
    _tagInt=0;
    _model=[[MiYiMenuSentModel alloc]init];
    
    _tagArray=[NSMutableArray array];
  
    _model.images =[NSMutableArray array];
    for ( ALAsset *set in _setArray)
    {
        MiYiPostsImageSModel  *postsImageSModel =[[MiYiPostsImageSModel alloc]init];

        CGImageRef ref = [[set  defaultRepresentation]fullResolutionImage];
        UIImage *img = [[UIImage alloc]initWithCGImage:ref];
        
        NSData *data =nil;
        while (1) {
            CGSize size =img.size;
            //图片大于2M的时候压缩
            data = [self imageWithImage:img scaledToSize:size];
            if (data.length < 2080000) {
                NSLog(@"%ld",(long)data.length);
                postsImageSModel.img_url =[UIImage imageWithData:data];
                [_model.images addObject:postsImageSModel];
                break;
            }else
            {
                img =[UIImage imageWithData:data];
            }
        }
        
    }
    
    MiYiPostsImageSModel *postsImageSModel = _model.images[0];
    _firstPhoto=(UIImage *)postsImageSModel.img_url;
    
    //标签图片
    MiYiTagEditorImageView *imageView =[[MiYiTagEditorImageView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-49-64-60-10}];
    imageView.postsImageSModel=postsImageSModel;
    _imageView=imageView;
    
    
    MiYiDynamicScrollView *dynamicScrollView = [[MiYiDynamicScrollView alloc] initWithFrame:CGRectMake(0, kWindowHeight-49-64-60-5, kWindowWidth, 60)];
    dynamicScrollView.viewController=self;
    dynamicScrollView.menuSentModel=_model;
    dynamicScrollView.imageRefreshBlock=^(NSString *imageIndex , id image)
    {
        _firstPhoto =image;
        _imageView.previewsImage.image=image;
        [_imageView imageTagFrame:NO];
        _tagInt=[imageIndex intValue];
        [_imageView removeTag];
        MiYiPostsImageSModel *model =self.model.images[_tagInt];
        for(int i =0 ; i<model.tags.count ;i++)
        {
            MiYiPostsImageTagIdsModel *tagModel = model.tags[i];
            [_imageView addtagViewimageClickinit:CGPointZero isClick:NO mode:tagModel];
        }
    };
    [self.view addSubview:dynamicScrollView];
    _dynamicScrollView=dynamicScrollView;
    
    
    MiYiTabBarButton *markCloth =[[MiYiTabBarButton alloc]initWithFrame:(CGRect){0,kWindowHeight-49-64,kWindowWidth/2-0.5,49}];
    markCloth.backgroundColor=[UIColor whiteColor];
    [markCloth setTitle:@"标记衣服" forState:UIControlStateNormal];
    [markCloth setImage:[UIImage imageNamed:@"Mark"] forState:UIControlStateNormal];
    [markCloth setBackgroundImage:[UIImage createImageWithColor:[UIColor darkGrayColor]] forState:UIControlStateHighlighted];
    [markCloth addTarget:self action:@selector(markClothClick:) forControlEvents:UIControlEventTouchUpInside];
    markCloth.adjustsImageWhenHighlighted=NO;
    [markCloth setExclusiveTouch:YES];
    
    MiYiTabBarButton *label =[[MiYiTabBarButton alloc]initWithFrame:(CGRect){CGRectGetMaxX(markCloth.frame),kWindowHeight-49-64,kWindowWidth/2-0.5,49}];
    label.backgroundColor=[UIColor whiteColor];
    [label setTitle:@"标签" forState:UIControlStateNormal];
    [label setImage:[UIImage imageNamed:@"labelIcon"] forState:UIControlStateNormal];
    [label setBackgroundImage:[UIImage createImageWithColor:[UIColor darkGrayColor]] forState:UIControlStateHighlighted];
    [label addTarget:self action:@selector(labelClick:) forControlEvents:UIControlEventTouchUpInside];
    label.adjustsImageWhenHighlighted=NO;
    [label setExclusiveTouch:YES];
    
    
    if (![self.title isEqualToString:@"求同款"]) {
        label.frame=(CGRect){0,kWindowHeight-49-64,kWindowWidth,49};
        markCloth.hidden=YES;
    }
    
    UIView *viewShow =[[UIView alloc]initWithFrame:(CGRect){0,kWindowHeight-49-64,kWindowWidth,1}];
    viewShow.backgroundColor=[UIColor darkGrayColor];
    viewShow.alpha=0.3;
    
    
    [self.view addSubview:imageView];
    [self.view addSubview:markCloth];
    [self.view addSubview:label];
    [self.view addSubview:viewShow];
    
    
    
}


-(void)markClothClick:(UIButton *)btn
{
    MiYiBoxSelectedVC *vc =[[MiYiBoxSelectedVC alloc]init];
    vc.title=btn.titleLabel.text;
    MiYiPostsImageSModel * model =_model.images[_tagInt];
    vc.model =model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)navItemClick
{
    __weak MiYiReleaseVC *weakSelf =self;
    MiYiSentVC *vc =[[MiYiSentVC alloc]init];
    vc.title =self.title;
    vc.model =_model;
    vc.dynamicRefreshBlock=^{
        for (int i=0; i<weakSelf.dynamicScrollView.imageViews.count; i++) {
            MiYiImageView *image =(MiYiImageView*)weakSelf.dynamicScrollView.imageViews[i];
            [image removeFromSuperview];
        }
        [weakSelf.dynamicScrollView.imageViews removeAllObjects];
        [weakSelf.dynamicScrollView.addImage removeFromSuperview];
        weakSelf.dynamicScrollView.menuSentModel=weakSelf.model;
        
        MiYiPostsImageSModel *model =weakSelf.model.images[0];
        _firstPhoto =model.img_url;
        _imageView.previewsImage.image=model.img_url;
        [_imageView imageTagFrame:NO];
        _tagInt=0;
        [_imageView removeTag];
        for(int i =0 ; i<model.tags.count ;i++)
        {
            MiYiPostsImageTagIdsModel *tagModel = model.tags[i];
            [_imageView addtagViewimageClickinit:CGPointZero isClick:NO mode:tagModel];
        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)labelClick:(UIButton *)btn
{
    __weak MiYiReleaseVC *weakSelf =self;
    MiYiTagsVC *vc =[[MiYiTagsVC alloc]init];
    vc.title=btn.titleLabel.text;
    MiYiPostsImageSModel * model =_model.images[_tagInt];
    vc.model =model;
    vc.blockUI=^{
        [weakSelf.imageView removeTag];
        MiYiPostsImageSModel *model =weakSelf.model.images[_tagInt];
        for(int i =0 ; i<model.tags.count ;i++)
        {
            MiYiPostsImageTagIdsModel *tagModel = model.tags[i];
            [weakSelf.imageView addtagViewimageClickinit:CGPointZero isClick:NO mode:tagModel];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)dealloc
{

    [Notification removeObserver:self];
}
@end
