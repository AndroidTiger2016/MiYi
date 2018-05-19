//
//  DynamicScrollView.m
//  MeltaDemo
//
//  Created by hejiangshan on 14-8-27.
//  Copyright (c) 2014年 hejiangshan. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "DynamicScrollView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "MiYiPhotoLibraryViewController.h"
#import "MiYiNavViewController.h"
#import "MiYiAssetManager.h"
#import "MBProgressHUD+YXL.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "MiYiBaseCommunityModel.h"
@implementation DynamicScrollView
{
    
    NSMutableArray *imageViews;
    float singleWidth;
    BOOL isDeleting;
    BOOL isClick;
    NSInteger tagInt;
}

@synthesize scrollView,imageViews,isDeleting;

- (id)initWithFrame:(CGRect)frame withImages:(MiYiMenuSentModel *)images
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor lightGrayColor];
        if (images==nil) {
           
            MiYiMenuSentModel *images=[[MiYiMenuSentModel alloc]init];
            self.imageS=images;
        }else
        {
            self.imageS = images;
        }
        imageViews =[NSMutableArray array];
        
        singleWidth = 60;
        [self initScrollView];
        [self initViews];
    }
    return self;
}

- (void)initScrollView
{
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = self.backgroundColor;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
    }
}

- (void)initViews
{
    if (self.imageS.images.count!=0) {
        for (int i = 0; i < self.imageS.images.count; i++) {
            MiYiPostsImageSModel *postsImageSModel = [MiYiPostsImageSModel objectWithKeyValues:self.imageS.images[i]];
            
            [self createImageViews:i withImage:postsImageSModel.img_url];
        }
    }else
    {
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.imageS.images.count * singleWidth +self.imageS.images.count*5+5 +65, self.scrollView.frame.size.height);
    
    _addImage=[[MiYiImageView alloc]initWithFrame:(CGRect){self.imageS.images.count * singleWidth +self.imageS.images.count*5+5 ,CGHeight(self.frame)/2-60/2,60,60}];
    _addImage.image=[UIImage imageNamed:@"addImage"];
    _addImage.userInteractionEnabled=YES;
    [_addImage addTarget:self action:@selector(addImageClick) forControlEvents:MiYiImageViewControlEventTap];
    [self.scrollView addSubview:_addImage];
}

- (void)createImageViews:(int)i withImage:(id )image
{
    MiYiImageView *imgView = [[MiYiImageView alloc] init];
    id classID =image;
    
    if ([classID isKindOfClass:[NSString class]]) {

        [imgView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"loading"]];
        
    }else
    {
        
        imgView.image=(UIImage *)image;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
        [imgView addGestureRecognizer:longPress];
    };
    
    imgView.frame = CGRectMake(singleWidth*i+i*5+5, CGHeight(self.frame)/2-60/2, singleWidth, self.scrollView.frame.size.height);
    imgView.userInteractionEnabled = YES;
    imgView.layer.masksToBounds=YES;
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    [imgView addTarget:self action:@selector(imgViewClick:) forControlEvents:MiYiImageViewControlEventTap];
    imgView.tag=i;
    if (!_isMenu) {
    if(i==0)
    {
        tagInt=0;
        imgView.layer.borderWidth=3;
        imgView.layer.borderColor=HEX_COLOR_THEME.CGColor;
    }
    }
    [self.scrollView addSubview:imgView];
    [imageViews addObject:imgView];
    
   
    
    
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    if (isDeleting) {
        [deleteButton setHidden:NO];
    } else {
        [deleteButton setHidden:YES];
    }
    deleteButton.frame = CGRectMake(singleWidth-25, -5, 30, 30);
    [imgView addSubview:deleteButton];
}

//长按调用的方法
- (void)longAction:(UILongPressGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {//长按开始
        isDeleting = !isDeleting;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                imageView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        for (UIImageView *imageView in imageViews) {
            UIButton *deleteButton = (UIButton *)imageView.subviews[0];
            if (isDeleting) {
                deleteButton.hidden = NO;
            } else {
                deleteButton.hidden = YES;
            }
        }
        
        

    }

}

-(void)deletebtn
{
    isDeleting =NO;
    for (UIImageView *imageView in imageViews) {
        UIButton *deleteButton = (UIButton *)imageView.subviews[0];
        if (isDeleting) {
            deleteButton.hidden = NO;
        } else {
            deleteButton.hidden = YES;
        }
    }
}
- (void)deleteAction:(UIButton *)button
{
    
    if (!_isMenu) {
    if(imageViews.count==1)
    {
        [MBProgressHUD showError:@"不能删除哦，最少也要留一张滴"];
        return;
    }
    }
    if (isClick) {
        
        return;
    }
    
    isDeleting = YES;   //正处于删除状态
    isClick =YES;
    MiYiImageView *imageView = (MiYiImageView *)button.superview;
    __block int index = (int)[imageViews indexOfObject:imageView];
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = scrollView;
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        
        [imageView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = (int)index + 1; i < imageViews.count; i++) {
                MiYiImageView *otherImageView = imageViews[i];
                CGRect originRect = otherImageView.frame;
                otherImageView.frame = rect;
                rect = originRect;
            }
            _addImage.frame =(CGRect){(self.imageViews.count * singleWidth +self.imageViews.count*5+5)-65,0,60,60};
            
        } completion:^(BOOL finished) {
            isClick =NO;
            [imageViews removeObject:imageView];
            [self.imageS.images removeObjectAtIndex:index];
            if (!_isMenu) {
            
            if (imageViews.count!=0) {
                MiYiImageView*tagImage=nil;
                BOOL isTag =NO;
                for (int i =0; i<imageViews.count; i++) {
                    
                    tagImage = (MiYiImageView*)imageViews[i];
                    if (tagImage.layer.borderWidth==3) {
                        isTag =YES;
                    }
                }
                if (!isTag) {
                    tagImage = (MiYiImageView*)imageViews[0];
                    tagImage.layer.borderColor=HEX_COLOR_THEME.CGColor;
                    tagImage.layer.borderWidth=3;
                    MiYiPostsImageSModel *postsImageSModel = self.imageS.images[0];
                    NSDictionary *dic =@{@"image":(UIImage *)postsImageSModel.img_url,
                                         @"index":[NSString stringWithFormat:@"%d",0]};
                    if(!_isAddImage)
                    [Notification postNotificationName:MiYiUnitedStatesTakeShowVCImage object:dic];
    
                }
                
            }
            }
            
            if (imageViews.count > 2) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakScroll.contentSize = CGSizeMake((singleWidth*imageViews.count+self.imageViews.count*5+5)+65, scrollView.frame.size.height);
                }];
                
            }
        }];
    }];
}



-(void)imgViewClick:(MiYiImageView *)img
{
    if (!_isMenu) {
    [self deletebtn];
    MiYiImageView*tagImage=nil;
    BOOL isTag =NO;
    for (int i =0; i<imageViews.count; i++) {
        
        tagImage = (MiYiImageView*)imageViews[i];
        if (tagImage.layer.borderWidth==3) {
            if(img.tag ==tagImage.tag)
            {
                isTag =YES;
            }else
            {
                tagImage.layer.borderWidth=0;
            }
        }
    }
    if (!isTag) {
        
        int index=0;
        if([imageViews containsObject:img])
        {
            index= (int)[imageViews indexOfObject:img];
            MiYiPostsImageSModel *postsImageSModel = [MiYiPostsImageSModel objectWithKeyValues:self.imageS.images[index]];
            id classID =postsImageSModel.img_url;
            
            NSDictionary *dic =[NSDictionary dictionary];
            if ([classID isKindOfClass:[NSString class]]) {
                 ;
                dic =@{@"image":postsImageSModel.img_url,
                                     @"index":[NSString stringWithFormat:@"%d",index]};
                
            }else
            {
                UIImage *image =(UIImage *)postsImageSModel.img_url;
                dic =@{@"image":image,
                                     @"index":[NSString stringWithFormat:@"%d",index]};
            }
           
            img.layer.borderColor=HEX_COLOR_THEME.CGColor;
            img.layer.borderWidth=3;
            
            
                if(!_isAddImage)
                {
                    [Notification postNotificationName:MiYiUnitedStatesTakeShowVCImage object:dic];
                }
                
            }
        }
    }
}

////添加一个新图片
- (void)addImageClick
{
    [self deletebtn];
    if (self.imageViews.count >=9) {
        [MBProgressHUD showError:@"只能选择9张哦"];
        return;
    }
    MiYiPhotoLibraryViewController *vc =[[MiYiPhotoLibraryViewController alloc]init];
    MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
    vc.classString =[self class];
    vc.blockSelect=^(NSMutableArray *selectArray)
    {
        
        for (int i=0; i<self.imageViews.count; i++) {
            MiYiImageView *image =(MiYiImageView*)self.imageViews[i];
            [image removeFromSuperview];
        }
        
        [self.imageViews removeAllObjects];
        [_addImage removeFromSuperview];
        for (int i = 0; i < selectArray.count; i++)
        {
            ALAsset *set =selectArray[i];
            CGImageRef ref = [[set  defaultRepresentation]fullResolutionImage];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            MiYiPostsImageSModel  *postsImageSModel =[[MiYiPostsImageSModel alloc]init];
            postsImageSModel.img_url=img;
            [self.imageS.images addObject:postsImageSModel];
        }
      
        [self initViews];
        
        if (imageViews.count > 4) {
            [self.scrollView setContentOffset:CGPointMake((imageViews.count-4)*singleWidth, 0) animated:YES];
        }
        
        if (!_isMenu) {
            MiYiPostsImageSModel *postsImageSModel = self.imageS.images[0];
            
            NSDictionary *dic =@{@"image":postsImageSModel.img_url,
                                 @"index":[NSString stringWithFormat:@"%d",0]};
            [Notification postNotificationName:MiYiUnitedStatesTakeShowVCImage object:dic];
        }
        
        
    };
    vc.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    vc.maxSelectCount=9-self.imageViews.count;

    [self.viewController presentViewController:nav animated:YES completion:nil];
    
}

-(void)dealloc
{
    [Notification removeObserver:self];
}
@end
